module Bl
  class Milestone < Thor
    include Bl::Requestable

    MILESTONE_PARAMS = {
      description: :string,
      startDate: :string,
      releaseDueDate: :string
    }

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/versions"
      super
    end

    desc 'list', 'list milestones'
    def list
      client.get(@url).body.each do |v|
        puts [
          v.id,
          v.projectId,
          v.name,
          v.description,
          v.startDate,
          v.releaseDueDate,
          v.archived
        ].join("\t")
      end
    end

    desc 'add [NAME...]', 'add milestones'
    options MILESTONE_PARAMS
    def add(*names)
      names.each do |name|
        res = client.post(
          @url,
          name: name,
          description: options[:description],
          startDate: options[:startDate],
          releaseDueDate: options[:releaseDueDate]
        )
        puts "milestone added: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'update [ID...]', 'update milestones'
    option :name, type: :string
    options MILESTONE_PARAMS
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", options)
        puts "milestone updated: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'delete [ID...]', 'delete milestones'
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}")
        puts "milestone deleted: #{res.body.id}\t#{res.body.name}"
      end
    end
  end
end
