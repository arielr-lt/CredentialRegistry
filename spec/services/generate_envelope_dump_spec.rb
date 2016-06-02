require 'generate_envelope_dump'
require 'envelope_transaction'

describe GenerateEnvelopeDump, type: :service do
  describe '#run' do
    let(:dump_file) { "#{LearningRegistry.dumps_path}/dump-#{Date.today}.json" }
    let(:generate_envelope_dump) do
      GenerateEnvelopeDump.new(Date.today)
    end

    before(:example) do
      envelope = create(:envelope)
      envelope.update_attributes(envelope_version: '1.0.0')
      envelope.update_attributes(deleted_at: Time.current)
    end

    after(:example) do
      File.unlink(dump_file)
    end

    it 'creates a dump file with the dumped envelopes' do
      generate_envelope_dump.run

      expect(File.exist?(dump_file)).to eq(true)
    end

    it 'contains dumped envelope transactions' do
      generate_envelope_dump.run

      dump = JSON.parse(File.read(dump_file))

      expect(dump.size).to eq(3)
      expect(dump.last['status']).to eq('deleted')
    end

    it 'stores a new dump in the database' do
      expect do
        generate_envelope_dump.run
      end.to change { EnvelopeDump.count }.by(1)
    end

    context 'dump already exists in the database' do
      it 'rejects the dump creation' do
        generate_envelope_dump.run

        expect do
          generate_envelope_dump.run
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end