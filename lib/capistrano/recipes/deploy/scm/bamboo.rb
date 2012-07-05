require 'typhoeus'
require 'json'

require 'capistrano/recipes/deploy/scm/base'

module Capistrano
  module Deploy
    module SCM
            
      class Bamboo < Base

        def load_result
          response = Typhoeus::Request.get("#{repository}/result/#{plan_key}/#{variable(:build_number)}.json?expand=artifacts", :username => variable(:scm_username), :password => variable(:scm_passphrase))
          result = JSON.parse(response.body)
        end

        def head
          "#{plan_key}-#{query_revision(variable(:build_number))}"
        end

        def query_revision(revision)
          if (revision.to_s =~ /\d+$/)
            revision
          elsif (revision =~ /latest$/) 
            result = load_result
            
            result["number"]
          else
            raise "invalid revision: #{revision}"
          end
        end

        def checkout(revision, destination)
          # TODO: graceful error handling
          result = load_result

          artifact = result["artifacts"]["artifact"].select { |artifact| artifact["name"] == variable(:artifact) }

          if (artifact.empty?)
            raise ArgumentError, "[err] build artifacts not found: perhaps you didn't correctly specify the artifact parameter?"
          end

          artifactUrl = artifact[0]["link"]["href"]
          build_actual = result["number"]

          # now do clever hackiness to detect whether this is a directory to be synced, or a single inline file/attachment
          artifact_headers = Typhoeus::Request.head(artifactUrl).headers_hash
          # if there's a content disposition of attachment, downolad the file directly. if inline, then ?. if no content disposition, then wget the whole directory.
          artifact_content_disposition = artifact_headers["Content-Disposition"]
          if (artifact_content_disposition.empty?)
            %Q{TMPDIR=`mktemp -d` && cd $TMPDIR && wget -m -nH -q #{artifactUrl} && mv artifact/#{plan_key}/shared/build-#{build_actual}/#{variable(:artifact)}/ "#{destination}" && rm -rf "$TMPDIR"}
          else
            # get the filename
            f = artifact_content_disposition.match(/filename="(.*?)"/)[1]
            %Q{TMPDIR=`mktemp -d` && cd $TMPDIR && wget -m -nH -q #{artifactUrl} -O #{f} && mkdir #{destination} && mv #{f} "#{destination}/" && rm -rf "$TMPDIR"}
          end
          
          ## previous artifact copy when things were only directories. for posterity only.
          # %Q{TMPDIR=`mktemp -d` && cd $TMPDIR && wget -m -nH -q #{artifactUrl} && mv artifact/#{plan_key}/shared/build-#{build_actual}/#{variable(:artifact)}/ "#{destination}" && rm -rf "$TMPDIR"}
        rescue ArgumentError => e
          logger.log(Logger::IMPORTANT, e.message)
          exit
        end
        
        def plan_key
          if (variable(:plan_key)) 
            variable(:plan_key)
          elsif (variable(:build_key))
            pk = variable(:build_key)
            pk.slice(0...pk.rindex('-'))
          else
            puts "d'oh"
          end
        end

        alias_method :export, :checkout

        # def log(from, to=nil)
        #   log_build_message(from, to)
        #   log_scm_message(from, to)
        #   'true'
        # end

        def diff(from, to=nil)
          logger.info 'bamboo does not support diff'
          'true'
        end
      end
    end
  end
end
