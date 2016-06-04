module Bl
  class File < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'list PATH', 'list files on PATH'
    def list(path='')
      client.get("projects/#{@config[:project_key]}/files/metadata/#{path}").body.each do |f|
        puts [f.id, f.type, f.dir, f.name, f.size, f.created, f.updated].join("\t")
      end
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
