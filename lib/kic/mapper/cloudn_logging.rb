# The document `pita.xml` contains both a default namespace and the 'georss'
# namespace (for the 'point' element).
class Kic::Mapper::CloudnLogging
  def parse(response)
    response = response.each_line.map do |line|
      unless /.*Response>$/=~line
        line
      end
    end.compact.join

    groups = Kic::Mapper::CloudnLogging::Groups.parse(response)

    if groups.class == Array
      [Kic::Mapper::CloudnLogging::Group.parse(response)]
    else
      groups.groups
    end
  end

  class Server
    include HappyMapper
    tag 'Server'

    element :identifier,  String, tag: 'Identifier'
    element :uuid,        String, tag: 'Uuid'
    element :name,        String, tag: 'Name'
    element :description, String, tag: 'Description'
    element :status,      String, tag: 'Status'
    element :ip_address,  String, tag: 'IpAddress'
  end

  class Servers
    include HappyMapper
    tag 'Servers'

    has_many :servers, Server
  end

  class Source
    include HappyMapper
    tag 'Source'

    element :identifier,   String, tag: 'Identifier'
    element :uuid,         String, tag: 'Uuid'
    element :name,         String, tag: 'Name'
    element :description,  String, tag: 'Description'
    element :logging_type, String, tag: 'LoggingType'
    element :tag,          String, tag: 'Tag'
    element :port,         String, tag: 'Port'
    element :status,       String, tag: 'Status'
  end

  class Sources
    include HappyMapper
    tag 'Sources'

    has_many :sources, Source
  end

  class Rule
    include HappyMapper
    tag 'Rule'
  end

  class Rules
    include HappyMapper
    tag 'Rules'

    has_many :rules, Rule
  end

  class SecurityGroup
    include HappyMapper
    tag 'SecurityGroup'

    element :identifier,   String, tag: 'Identifier'
    element :uuid,         String, tag: 'Uuid'
    element :name,         String, tag: 'Name'
    element :description,  String, tag: 'Description'
    element :status,       String, tag: 'Status'
    element :rules,        Rule
  end

  class SecurityGroups
    include HappyMapper
    tag 'SecurityGroups'

    has_many :security_groups, SecurityGroup
  end

  class Group
    include HappyMapper
    tag 'Group'

    element :identifier,       String, tag: 'Identifier'
    element :uuid,             String, tag: 'Uuid'
    element :name,             String, tag: 'Name'
    element :description,      String, tag: 'Description'
    element :status,           String, tag: 'Status'
    element :retention_period, String, tag: 'RetentionPeriod'
    element :instance_class,   String, tag: 'InstanceClass'
    element :disk_size,        String, tag: 'DiskSize'
    element :servers,          Server
    element :sources,          Source
    element :security_groups,  SecurityGroup
  end

  class Groups
    include HappyMapper
    tag 'Groups'

    has_many :groups, Group
  end
end
