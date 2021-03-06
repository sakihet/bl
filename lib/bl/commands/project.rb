module Bl
  module Commands
    class Project < Command
      def initialize(*)
        @config = Bl::Config.instance
        @url = 'projects'
        super
      end

      # TODO:
      # desc 'activities ID', 'show project activities'
      # def activities(id)
      #   res = request(:get, "#{@url}/#{id}/activities")
      #   res.body.each do |a|
      #     p a.pretty_inspect
      #   end
      # end

      desc 'list', 'list projects'
      option :all
      def list
        opts = {}
        opts[:archived] = false unless options[:all]
        res = request(:get, @url, opts)
        print_response(res, :project)
      end

      desc 'show', 'show project'
      def show(id)
        res = request(:get, "#{@url}/#{id}")
        print_response(res, :project)
      rescue => e
        puts e.message
      end

      desc 'add', 'add project'
      option :key, required: true, type: :string
      option :chartEnabled, type: :boolean, default: false
      option :projectLeaderCanEditProjectLeader, type: :boolean, default: false
      option :subtaskingEnabled, type: :boolean, default: false
      option :textFormattingRule, type: :string, default: 'markdown'
      def add(name)
        res = request(:post, @url, {name: name}.merge(delete_class_options(options.to_h)))
        puts 'project added'
        print_response(res, :project)
      end

      desc 'update', 'update project'
      options PROJECT_PARAMS
      def update(id)
        res = request(:patch, "#{@url}/#{id}", delete_class_options(options.to_h))
        puts 'project updated'
        print_response(res, :project)
      end

      desc 'delete', 'delete project'
      def delete(id)
        res = request(:delete, "#{@url}/#{id}")
        puts 'project deleted'
        print_response(res, :project)
      end

      desc 'status ID', 'show project status'
      def status(id)
        all_issues_count = count_issues(id)
        open_issues_count = count_issues(id, statusId: [1])
        in_progress_issues_count = count_issues(id, statusId: [2])
        resolved_issues_count = count_issues(id, statusId: [3])
        closed_issues_count = count_issues(id, statusId: [4])
        puts "#{closed_issues_count} / #{all_issues_count}"
        puts "open: #{open_issues_count}"
        puts "in progress: #{in_progress_issues_count}"
        puts "resolved: #{resolved_issues_count}"
        puts "closed: #{closed_issues_count}"
      end

      desc 'progress ID', 'show project progress'
      def progress(id)
        puts '--status--'
        all_issues_count = count_issues(id)
        closed_issues_count = count_issues(id, statusId: [4])
        puts "#{closed_issues_count} / #{all_issues_count}"
        puts '--milestone--'
        versions = request(:get, "projects/#{@config[:project_key]}/versions").body
        versions.each do |version|
          all_issues_count = count_issues(id, milestoneId: [version.id])
          closed_issues_count = count_issues(id, milestoneId: [version.id], statusId: [4])
          puts "#{version.name}: #{closed_issues_count} / #{all_issues_count}"
        end
        puts '--category--'
        categories = request(:get, "projects/#{@config[:project_key]}/categories").body
        categories.each do |category|
          all_issues_count = count_issues(id, categoryId: [category.id])
          closed_issues_count = count_issues(id, categoryId: [category.id], statusId: [4])
          puts "#{category.name}: #{closed_issues_count} / #{all_issues_count}"
        end
      end

      desc 'users ID', 'show project users'
      def users(id)
        res = request(:get, "#{@url}/#{id}/users")
        puts formatter.render(res.body, fields: USER_FIELDS)
      end

      desc 'image ID', 'get project image file'
      def image(id)
        res = request(:get, "#{@url}/#{id}/image")
        ::File.open(res.body.filename, 'wb') { |f| f.write(res.body.content) }
        puts "#{res.body.filename} generated"
      end

      private

      def count_issues(project_id, args={})
        args = {
          projectId: [project_id],
        }.merge(args)
        request(
          :get,
          'issues/count',
          args
        ).body.count
      end

    end
  end
end
