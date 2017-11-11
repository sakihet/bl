module Bl
  module Commands
    class File < Command
      def initialize(*)
        @config = Bl::Config.instance
        @url = "projects/#{@config[:project_key]}"
        super
      end

      desc 'list PATH', 'list files on PATH'
      def list(path = '')
        res = request(:get, "#{@url}/files/metadata/#{path}")
        print_response(res, :file)
      end

      desc 'get [ID...]', 'get files'
      def get(*ids)
        ids.each do |id|
          res = request(:get, "#{@url}/files/#{id}")
          f = ::File.new(res.body.filename, 'w')
          f.write(res.body.content)
          f.close
          puts "file #{id} #{res.body.filename} downloaded."
        end
      end
    end
  end
end
