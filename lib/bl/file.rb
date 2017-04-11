module Bl
  class File < Command

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'list PATH', 'list files on PATH'
    def list(path='')
      res = client.get("projects/#{@config[:project_key]}/files/metadata/#{path}")
      puts formatter.render(res.body, fields: %i(id type dir name size created updated))
    end

    desc 'get [ID...]', 'get files'
    def get(*ids)
      ids.each do |id|
        res = client.get("projects/#{@config[:project_key]}/files/#{id}")
        f = ::File.new(res.body.filename, "w")
        f.write(res.body.content)
        f.close
        puts "file #{id} #{res.body.filename} downloaded."
      end
    end
  end
end
