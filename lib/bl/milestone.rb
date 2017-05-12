module Bl
  class Milestone < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/versions"
      super
    end

    desc 'list', 'list milestones'
    option :all
    def list
      res = request(:get, @url)
      if options[:all]
      else
        res.body.select! { |m| m.archived == false } unless options[:all]
      end
      print_response(res)
    end

    desc 'add [NAME...]', 'add milestones'
    options MILESTONE_PARAMS
    def add(*names)
      names.each do |name|
        res = request(:post, 
          @url,
          name: name,
          description: options[:description],
          startDate: options[:startDate],
          releaseDueDate: options[:releaseDueDate]
        )
        puts 'milestone added'
        print_response(res)
      end
    end

    desc 'update [ID...]', 'update milestones'
    option :name, type: :string
    options MILESTONE_PARAMS
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", delete_class_options(options))
        puts 'milestone updated'
        print_response(res)
      end
    end

    desc 'delete [ID...]', 'delete milestones'
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}")
        puts 'milestone deleted'
        print_response(res)
      end
    end

    private

    def print_response(res)
      puts formatter.render(res.body, fields: MILESTONE_FIELDS)
    end
  end
end
