module Bl
  class Milestone < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'add NAME', 'add milestones'
    def add(*names)
      names.each do |name|
        res = client.post("projects/#{@config[:project_key]}/versions", name: name)
        puts "milestone added: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'delete MILESTONE_ID', 'delete milestones'
    def delete(*ids)
      ids.each do |id|
        res = client.delete("projects/#{@config[:project_key]}/versions/#{id}")
        puts "milestone deleted: #{res.body.id}\t#{res.body.name}"
      end
    end
  end
end
