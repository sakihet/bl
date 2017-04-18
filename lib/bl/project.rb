module Bl
  class Project < Command
    def initialize(*)
      @config = Bl::Config.instance
      @url = 'projects'
      super
    end

    desc 'list', 'list projects'
    def list
      res = client.get(@url)
      print_response(res)
    end

    desc 'add', 'add project'
    option :key, required: true, type: :string
    option :chartEnabled, type: :boolean, default: false
    option :projectLeaderCanEditProjectLeader, type: :boolean, default: false
    option :subtaskingEnabled, type: :boolean, default: false
    option :textFormattingRule, type: :string, default: 'markdown'
    def add(name)
      res = client.post(@url, {name: name}.merge(delete_class_options(options.to_h)))
      puts 'project added'
      print_response(res)
    end

    desc 'update', 'update project'
    options PROJECT_PARAMS
    def update(id)
      res = client.patch("#{@url}/#{id}", delete_class_options(options.to_h))
      puts 'project updated'
      print_response(res)
    end

    desc 'delete', 'delete project'
    def delete(id)
      res = client.delete("#{@url}/#{id}")
      puts 'project deleted'
      print_response(res)
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
      versions = client.get("projects/#{@config[:project_key]}/versions").body
      versions.each do |version|
        all_issues_count = count_issues(id, milestoneId: [version.id])
        closed_issues_count = count_issues(id, milestoneId: [version.id], statusId: [4])
        puts "#{version.name}: #{closed_issues_count} / #{all_issues_count}"
      end
      puts '--category--'
      categories = client.get("projects/#{@config[:project_key]}/categories").body
      categories.each do |category|
        all_issues_count = count_issues(id, categoryId: [category.id])
        closed_issues_count = count_issues(id, categoryId: [category.id], statusId: [4])
        puts "#{category.name}: #{closed_issues_count} / #{all_issues_count}"
      end
    end

    desc 'users ID', 'show project users'
    def users(id)
      res = client.get("#{@url}/#{id}/users")
      puts formatter.render(res.body, fields: USER_FIELDS)
    end

    private

    def count_issues(project_id, args={})
      args = {
        projectId: [project_id],
      }.merge(args)
      client.get(
        'issues/count',
        args
      ).body.count
    end

    def print_response(res)
      puts formatter.render(res.body, fields: PROJECT_FIELDS)
    end
  end
end
