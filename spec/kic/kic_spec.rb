require 'spec_helper'

describe Kic do
  subject do
    kic.exec(query_param)
  end

  let(:kic) { Kic.new(kic_param) }

  context '正常にActionを実行出来ている場合' do
    let(:kic_param) do
      {
        mapper:        :cloudn_logging,
        auth_type:     :aws_signature_v2,
        endpoint_fqdn: 'logging-api.jp-e1.cloudn-service.com',
        endpoint_path: '/',
        endpoint_port: 443,
        endpoint_ssl:  true,
        access_key:    'Y1BH3KCO8M89YAHCOMSP',
        secret_key:    'fcatVboovQMNVUfEm9XIbma9DTDvVa5jYJFAJ1KU'
      }
    end

    let(:query_param) do
      {
        Action:          'CreateLoggingServerGroup',
        Identifier:      'u1logging-identifier',
        Name:            'u1logging-name',
        Description:     'u1logging-description',
        RetentionPeriod: '2'
      }
    end

    before :each do
      allow(kic).to receive(:get_request)   { true }
      allow(kic).to receive(:response)      { stub_create_logging_server_group }
      allow(kic).to receive(:response_code) { 200 }

      subject
    end

    it 'responseが返ってきている事' do
      puts kic.response

      expect(kic.response).to be_a_kind_of String
    end
  end

  def stub_create_logging_server_group
    <<-EOF.unindent
    <?xml version="1.0" encoding="UTF-8"?>
    <CreateLoggingServerGroupResponse>
      <Group>
        <Identifier>u1logging-identifier</Identifier>
        <Uuid>log-u-group-9438ffca-71e3-4243-b548-a98c73c70231</Uuid>
        <Name>u1logging-name</Name>
        <Description>u1logging-description</Description>
        <Status>creating</Status>
        <RetentionPeriod>2</RetentionPeriod>
        <InstanceClass>log.m1.medium</InstanceClass>
        <DiskSize>40</DiskSize>
        <Servers>
          <Server>
            <Identifier>u1logging-identifier-0</Identifier>
            <Uuid>log-u-server-0d427366-6b11-4742-ab3d-b279cf02fd94</Uuid>
            <Name></Name>
            <Description></Description>
            <Status>creating</Status>
            <IpAddress></IpAddress>
          </Server>
        </Servers>
        <Sources>
          <Source>
            <Identifier>u1logging-identifier-syslog</Identifier>
            <Uuid>log-u-source-89879a5f-2319-4545-85a7-b19c689ebd8f</Uuid>
            <Name></Name>
            <Description></Description>
            <LoggingType>syslog</LoggingType>
            <Tag>syslog</Tag>
            <Port>5140</Port>
            <Status>creating</Status>
          </Source>
          <Source>
            <Identifier>u1logging-identifier-td</Identifier>
            <Uuid>log-u-source-182353b1-3d30-49f5-9b27-440d80847bd3</Uuid>
            <Name></Name>
            <Description></Description>
            <LoggingType>td</LoggingType>
            <Tag>td</Tag>
            <Port>24224</Port>
            <Status>creating</Status>
          </Source>
        </Sources>
        <Filters/>
        <SecurityGroups>
          <SecurityGroup>
            <Identifier>u1logging-identifier</Identifier>
            <Uuid>log-u-sg-a8d90a96-20a9-42e5-b8a8-19c3769270b9</Uuid>
            <Name></Name>
            <Description></Description>
            <Status>modifying</Status>
            <Rules/>
          </SecurityGroup>
        </SecurityGroups>
      </Group>
    </CreateLoggingServerGroupResponse>
    EOF
  end
end
