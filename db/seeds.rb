EnvelopeCommunity.create([{ name: 'learning_registry',
                            backup_item: 'learning-registry-test' },
                          { name: 'ce_registry',
                            backup_item: 'ce-registry-test',
                            default: true }])

admin = Admin.create(name: 'ce_admin')
organization = Organization.create(name: 'Generic Organization', admin: admin)
publisher = Publisher.create(name: 'ce', admin: admin, super_publisher: true)
OrganizationPublisher.create(organization: organization, publisher: publisher)
User.create(email: 'user@ce.org', publisher: publisher)
