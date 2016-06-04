module Bl
  class Project < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'projects'
      super
    end

    desc 'list', 'list projects'
    def list
      client.get(@url).body.each do |p|
        puts [p.id, p.projectKey, p.name].join("\t")
      end
    end

    desc 'status ID', 'show project status'
    def status(id)
      all_issues_count = count_issues(id)
      open_issues_count = count_issues(id, 1)
      in_progress_issues_count = count_issues(id, 2)
      resolved_issues_count = count_issues(id, 3)
      closed_issues_count = count_issues(id, 4)
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
      closed_issues_count = count_issues(id, 4)
      puts "#{closed_issues_count} / #{all_issues_count}"
      puts '--category--'
      categories = client.get("projects/#{@config[:project_key]}/categories").body
      categories.each do |category|
        all_issues_count = client.get(
          'issues/count',
          categoryId: [category.id]
        ).body.count
        closed_issues_count = client.get(
          'issues/count',
          categoryId: [category.id],
          statusId: [4]
        ).body.count
        puts "#{category.name}: #{closed_issues_count} / #{all_issues_count}"
      end
    end

    desc 'users ID', 'show project users'
    def users(id)
      client.get("#{@url}/#{id}/users").body.each do |u|
        puts [
          u.id,
          u.userId,
          u.name,
          u.roleType,
          u.lang,
          u.mailAddress
        ].join("\t")
      end
    end

    private

    def count_issues(project_id, *status)
      client.get(
        'issues/count',
        projectId: [project_id],
        statusId: status
      ).body.count
    end
  end
end
