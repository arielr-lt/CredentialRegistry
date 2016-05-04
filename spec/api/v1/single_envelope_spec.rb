describe API::V1::SingleEnvelope do
  context 'GET /api/envelope/:id' do
    let!(:envelopes) do
      [create(:envelope), create(:envelope)]
    end

    subject { envelopes.first }

    before(:each) do
      with_versioned_envelope(subject) do
        get "/api/envelopes/#{subject.envelope_id}"
      end
    end

    it { expect_status(:ok) }

    it 'retrieves the desired envelope' do
      expect_json(envelope_id: subject.envelope_id)
      expect_json(resource_format: 'json')
      expect_json(resource_encoding: 'jwt')
    end

    it 'displays the appended node headers' do
      base_url = "/api/envelopes/#{subject.envelope_id}"

      expect_json_keys('node_headers', %i(resource_digest versions created_at
                                          updated_at deleted_at))
      expect_json('node_headers.versions.1', head: true)
      expect_json('node_headers.versions.1', url: base_url)
      expect_json('node_headers.versions.0', head: false)
      expect_json('node_headers.versions.0',
                  url: "#{base_url}/versions/#{subject.versions.last.id}")
    end
  end

  context 'PATCH /api/envelopes/:id' do
    it_behaves_like 'a signed endpoint', :patch, uses_id: true

    let(:envelope) { create(:envelope, :with_id) }

    context 'with valid parameters' do
      before(:each) do
        resource = jwt_encode(attributes_for(:resource, name: 'Updated'))
        patch "/api/envelopes/#{envelope.envelope_id}",
              attributes_for(:envelope, resource: resource)
      end

      it { expect_status(:ok) }

      it 'updates some data inside the resource' do
        envelope.reload

        expect(envelope.decoded_resource.name).to eq('Updated')
      end

      it 'returns the updated envelope' do
        expect_json(envelope_id: envelope.envelope_id)
        expect_json(envelope_version: envelope.envelope_version)
      end
    end

    context 'with invalid parameters' do
      before(:each) { patch '/api/envelopes/non-existent-envelope-id', {} }

      it { expect_status(:not_found) }

      it 'returns the list of validation errors' do
        expect_json_keys(:errors)
        expect_json('errors.0', 'Couldn\'t find Envelope')
      end
    end

    context 'with a different resource and public key' do
      before(:each) do
        patch "/api/envelopes/#{envelope.envelope_id}",
              attributes_for(:envelope, :from_different_user)
      end

      it { expect_status(:unprocessable_entity) }

      it 'raises an original user validation error' do
        expect_json('errors.0', 'can only be updated by the original user')
      end
    end
  end

  context 'DELETE /api/envelopes/:id' do
    it_behaves_like 'a signed endpoint', :delete, uses_id: true

    context 'with valid parameters' do
      let!(:envelope) { create(:envelope) }

      before(:each) do
        delete "/api/envelopes/#{envelope.envelope_id}",
               attributes_for(:delete_token)
      end

      it { expect_status(:no_content) }

      it 'marks the envelope as deleted' do
        envelope.reload

        expect(envelope.deleted_at).not_to be_nil
      end
    end

    context 'trying to delete a non existent envelope' do
      before(:each) { delete '/api/envelopes/non-existent-envelope-id' }

      it { expect_status(:not_found) }

      it 'returns the list of validation errors' do
        expect_json('errors.0', 'Couldn\'t find Envelope')
      end
    end
  end
end