require 'erb'
require_relative 'contact'

class WhoisRecord < ActiveRecord::Base
  BLOCKED = 'Blocked'.freeze
  RESERVED = 'Reserved'.freeze
  DISCARDED = 'deleteCandidate'.freeze
  AT_AUCTION = 'AtAuction'.freeze
  PENDING_REGISTRATION = 'PendingRegistration'.freeze

  TEMPLATE_DIR = File.join(File.dirname(__FILE__), '../views/whois_record/').freeze
  TEMPLATE_INACTIVE = (TEMPLATE_DIR + "inactive.erb").freeze
  LEGAL_PERSON_TEMPLATE = (TEMPLATE_DIR + "legal_person.erb").freeze
  PRIVATE_PERSON_TEMPLATE = (TEMPLATE_DIR + "private_person.erb").freeze

  def unix_body
    file = File.new(template)
    ERB.new(file.read, nil, "-").result(binding)
  end

  def template
    if active?
      private_or_legal_person_template
    else
      TEMPLATE_INACTIVE
    end
  end

  def registrant
    deserialize_registrant
  end

  def admin_contacts
    json['admin_contacts'].map { |serialized_contact| deserialize_contact(serialized_contact) }
  end

  def tech_contacts
    json['tech_contacts'].map { |serialized_contact| deserialize_contact(serialized_contact) }
  end

  private

  def deserialize_registrant
    Contact.new(name: json['registrant'],
                disclosed_attributes: json['registrant_disclosed_attributes'])
  end

  def deserialize_contact(serialized_contact)
    Contact.new(name: serialized_contact['name'],
                disclosed_attributes: serialized_contact['disclosed_attributes'])
  end

  def private_person?
    json['registrant_kind'] != 'org'
  end

  def private_or_legal_person_template
    if private_person?
      PRIVATE_PERSON_TEMPLATE
    else
      LEGAL_PERSON_TEMPLATE
    end
  end

  def active?
    (([BLOCKED, RESERVED, DISCARDED, AT_AUCTION, PENDING_REGISTRATION] & json['status']).empty?)
  end
end
