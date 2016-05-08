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
      all_issues_count = client.get('issues/count', projectId: [id]).body.count
      open_issues_count = client.get('issues/count', projectId: [id], statusId: [1]).body.count
      in_progress_issues_count = client.get('issues/count', projectId: [id], statusId: [2]).body.count
      resolved_issues_count = client.get('issues/count', projectId: [id], statusId: [3]).body.count
      closed_issues_count = client.get('issues/count', projectId: [id], statusId: [4]).body.count
      puts "#{closed_issues_count} / #{all_issues_count}"
      puts "open: #{open_issues_count}"
      puts "in progress: #{in_progress_issues_count}"
      puts "resolved: #{resolved_issues_count}"
      puts "closed: #{closed_issues_count}"
    end

    desc 'users ID', 'show project users'
    def users(id)
      client.get("#{@url}/#{id}/users").body.each do |u|
        puts [u.id, u.userId, u.name, u.roleType, u.lang, u.mailAddress].join("\t")
      end
    end
  end
end
