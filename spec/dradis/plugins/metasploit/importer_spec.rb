require "spec_helper"
require "ostruct"

describe Dradis::Plugins::Metasploit::Importer do
  let(:plugin) { Dradis::Plugins::Metasploit }

  let(:content_service)  { Dradis::Plugins::ContentService.new(plugin: plugin) }
  let(:template_service) { Dradis::Plugins::TemplateService.new(plugin: plugin) }

  let(:importer) {
    described_class.new(
      content_service: content_service,
      template_service: template_service
    )
  }

  before do
    # Stub template service
    templates_dir = File.expand_path('../../../templates', __FILE__)
    allow_any_instance_of(Dradis::Plugins::TemplateService).to \
      receive(:default_templates_dir).and_return(templates_dir)

    # Stub dradis-plugins methods
    #
    # They return their argument hashes as objects mimicking
    # Nodes, Issues, etc
    %i[node note evidence issue].each do |model|
      allow(content_service).to receive(:"create_#{model}") do |args|
        OpenStruct.new(args)
      end
    end
  end

  let(:example_xml) { 'spec/fixtures/files/simple.xml' }

  def run_import!
    importer.import(file: example_xml)
  end

  context "valid XML file" do
    it "detects an invalid XML root tag" do
      expect_to_create_note_with(text: 'Invalid XML')
      expect(importer.import(file: 'spec/fixtures/files/qualys.xml')).to eq(false)
    end
    it "detects a not-supported Metasploit XML version" do
      expect_to_create_note_with(text: 'Invalid Metasploit version')
      expect(importer.import(file: 'spec/fixtures/files/msf4.xml')).to eq(false)
    end
  end
  


  def expect_to_create_node_with(label:)
    expect(content_service).to receive(:create_node).with(
      hash_including label: label
    ).once
  end

  def expect_to_create_note_with(node_label: nil, text:)
    expect(content_service).to receive(:create_note) do |args|
      expect(args[:text]).to include text
      expect(args[:node].label).to eq node_label unless node_label.nil?
    end.once
  end

  def expect_to_create_issue_with(text:)
    expect(content_service).to receive(:create_issue) do |args|
      expect(args[:text]).to include text
      OpenStruct.new(args)
    end.once
  end

  def expect_to_create_evidence_with(content:, issue:, node_label:)
    expect(content_service).to receive(:create_evidence) do |args|
      expect(args[:content]).to include content
      expect(args[:issue].text).to include issue
      expect(args[:node].label).to eq node_label
    end.once
  end


end

