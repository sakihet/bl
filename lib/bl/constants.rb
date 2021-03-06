module Bl
  ACTIVITY_TYPES = {
    1 => 'Issue Created',
    2 => 'Issue Updated',
    3 => 'Issue Commented',
    4 => 'Issue Deleted',
    5 => 'Wiki Created',
    6 => 'Wiki Updated',
    7 => 'Wiki Deleted',
    8 => 'File Added',
    9 => 'File Updated',
    10 => 'File Deleted',
    11 => 'SVN Committed',
    12 => 'Git Pushed',
    13 => 'Git Repository Created',
    14 => 'Issue Multi Updated',
    15 => 'Project User Added',
    16 => 'Project User Deleted',
    17 => 'Comment Notification Added',
    18 => 'Pull Request Added',
    19 => 'Pull Request Updated',
    20 => 'Comment Added on Pull Request'
  }
  CATEGORY_FIELDS = %i(id name displayOrder)
  FILE_FIELDS = %i(id type dir name size created updated)
  GIT_REPO_FIELDS = %i(
    id
    projectId
    name
    sshUrl
    pushedAt
    created
    updated
  )
  ISSUE_BASE_ATTRIBUTES = {
    summary: :string,
    parentIssueId: :numeric,
    description: :string,
    statusId: :numeric,
    resolutionId: :numeric,
    dueDate: :string,
    issueTypeId: :numeric,
    categoryId: :array,
    versionId: :array,
    milestoneId: :array,
    priorityId: :numeric,
    assigneeId: :numeric
  }
  ISSUES_COUNT_MAX = 100
  ISSUE_FIELDS = %i(
    issueType
    issueKey
    summary
    assignee
    status
    priority
    startDate
    dueDate
    created
    updated
  )
  ISSUES_PARAMS = {
    projectId: :array,
    issueTypeId: :array,
    categoryId: :array,
    versionId: :array,
    milestoneId: :array,
    statusId: :array,
    priorityId: :array,
    assigneeId: :array,
    createdUserId: :array,
    resolutionId: :array,
    parentChild: :numeric,
    attachment: :boolean,
    sharedFile: :boolean,
    sort: :string,
    order: :string,
    offset: :numeric,
    count: :numeric,
    createdSince: :string,
    createUntil: :string,
    updatedSince: :string,
    updatedUntil: :string,
    startDateSince: :string,
    startDateUntil: :string,
    dueDateSince: :string,
    dueDateUntil: :string,
    id: :array,
    parentIssueId: :array,
    keyword: :string
  }
  MILESTONE_FIELDS = %i(id projectId name description startDate releaseDueDate archived)
  MILESTONE_PARAMS = {
    description: :string,
    startDate: :string,
    releaseDueDate: :string
  }
  PROJECT_FIELDS = %i(
    id
    projectKey
    name
    chartEnabled
    subtaskingEnabled
    projectLeaderCanEditProjectLeader
    textFormattingRule
    archived
  )
  PROJECT_PARAMS = {
    name: :string,
    key: :string,
    chartEnabled: :boolean,
    projectLeaderCanEditProjectLeader: :boolean,
    subtaskingEnabled: :boolean,
    textFormattingRule: :boolean
  }
  PULL_REQUEST_FIELDS = %i(
    id
    projectId
    repositoryId
    number
    summary
    description
    base
    branch
    baseCommit
    branchCommit
    closeAt
    mergeAt
    created
    updated
  )
  ROLES = [
    {id: 1, name: 'Administrator'},
    {id: 2, name: 'Normal User'},
    {id: 3, name: 'Reporter'},
    {id: 4, name: 'Viewer'},
    {id: 5, name: 'Guest Reporter'},
    {id: 6, name: 'Guest Viewer'}
  ]
  SPACE_DISK_USAGE = %i(
    capacity
    issue
    wiki
    file
    subversion
    git
  )
  SPACE_DISK_USAGE_DETAILS_FIELDS = %i(
    projectId
    issue
    wiki
    file
    subversion
    git
  )
  SPACE_FIELDS = %i(
    spaceKey
    name
    ownerId
    lang
    timezone
    reportSendTime
    textFormattingRule
    created
    updated
  )
  SPACE_NOTIFICATION_FIELDS = %i(
    content
    updated
  )
  TYPE_COLORS = %w(
    #e30000
    #934981
    #814fbc
    #007e9a
    #ff3265
    #666665
    #990000
    #2779ca
    #7ea800
    #ff9200
  )
  USER_FIELDS = %i(
    id
    userId
    name
    roleType
    lang
    mailAddress
  )
  USER_PARAMS = {
    password: :string,
    name: :string,
    mailAddress: :string,
    roleType: :numeric
  }
  WATCHINGS_PARAMS = {
    order: :string,
    sort: :string,
    count: :numeric,
    offset: :numeric,
    resourceAlreadyRead: :boolean,
    issueId: :array
  }
  WEBHOOK_FIELDS = %i(id name description created updated)
  WEBHOOK_PARAMS = {
    name: :string,
    description: :string,
    hookUrl: :string,
    allEvent: :boolean,
    activityTypeIds: :array
  }
  WIKI_FIELDS = %i(id projectId name created updated)
end
