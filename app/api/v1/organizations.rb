require 'entities/organization'
require 'helpers/shared_helpers'
require 'organization'
require 'policies/organization_policy'

module API
  module V1
    # Organization API endpoints
    class Organizations < Grape::API
      helpers SharedHelpers

      resources :organizations do
        desc 'Returns all the organizations'
        get do
          present Organization.order(:name), with: API::Entities::Organization
        end

        namespace do
          before do
            authenticate!
          end

          desc 'Creates a new organization'
          params do
            requires :name, type: String, desc: 'Organization name'
          end
          post do
            authorize Organization, :create?
            organization = current_user.admin.organizations.create!(params)
            present organization, with: API::Entities::Organization
          end

          desc 'Deletes an existing organization'
          delete ':id', requirements: { id: /(.*)/ } do
            organization = Organization.find(params[:id])
            authorize organization, :destroy?

            begin
              organization.destroy
              body ''
            rescue ActiveRecord::InvalidForeignKey
              json_error!([Organization::NOT_EMPTY], nil, 422)
            end
          end
        end

        route_param :organization_id do
          resource :envelopes do
            desc 'Returns the envelopes owned by an organization'
            params do
              use :pagination
            end
            get do
              organization = Organization.find(params[:organization_id])
              envelopes = paginate(organization.owned_envelopes)
              present envelopes, with: API::Entities::Envelope
            end
          end
        end
      end
    end
  end
end
