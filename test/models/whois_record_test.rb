require_relative '../test_helper'
require_relative '../../app/models/whois_record'

class DiscardedWhoisRecordTest < Minitest::Test
  def setup
    super

    create_discarded_record
    create_private_person_record
    create_legal_person_record
  end

  def teardown
    super

    WhoisRecord.delete_all
  end

  def test_discarded_record_template
    text = begin
      "Estonia .ee Top Level Domain WHOIS server\n" \
      "\n" \
      "Domain:\n" \
      "name:       discarded-domain.test\n" \
      "status:     deleteCandidate\n" \
      "\n" \
      "Estonia .ee Top Level Domain WHOIS server\n" \
      "More information at http://internet.ee\n" \
      ""
    end

    assert_equal(text, @discarded_record.unix_body)
  end

  def test_legal_person_record_template
    text = begin
      "The information obtained through .ee WHOIS is subject to database\n" \
      "protection according to the Estonian Copyright Act and international\n" \
      "conventions. All rights are reserved to Estonian Internet Foundation.\n" \
      "Search results may not be used for commercial,advertising, recompilation,\n" \
      "repackaging, redistribution, reuse, obscuring or other similar activities.\n" \
      "Downloading of information about domain names for the creation of your own\n" \
      "database is not permitted. If any of the information from .ee WHOIS is\n" \
      "transferred to a third party, it must be done in its entirety. This server\n" \
      "must not be used as a backend for a search engine.\n" \
      "\n" \
      "Estonia .ee Top Level Domain WHOIS server\n" \
      "\n" \
      "Domain:\n" \
      "name:       companydomain.test\n" \
      "status:     inactive\n" \
      "registered: 2018-04-25 14:10:41 +03:00\n" \
      "changed:    2018-04-25 14:10:41 +03:00\n" \
      "expire:     2018-07-25\n" \
      "outzone:    \n" \
      "delete:     \n" \
      "\n" \
      "Registrant:\n" \
      "name:       test\n" \
      "org id:     123\n" \
      "country:    EE\n" \
      "email:      Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "changed:    2018-04-25 14:10:41 +03:00\n" \
      "\n" \
      "Administrative contact:\n" \
      "name:       Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "email:      Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "changed:    Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "\n" \
      "Technical contact:\n" \
      "name:       Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "email:      Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "changed:    Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "\n" \
      "Registrar:\n" \
      "name:       test\n" \
      "url:        \n" \
      "phone:      \n" \
      "changed:    2018-04-25 14:10:39 +03:00\n" \
      "\n" \
      "\n" \
      "Estonia .ee Top Level Domain WHOIS server\n" \
      "More information at http://internet.ee\n" \
      ""
    end

    assert_equal(text, @legal_person_record.unix_body)
  end

  def test_private_person_record_template
    text = begin
      "The information obtained through .ee WHOIS is subject to database\n" \
      "protection according to the Estonian Copyright Act and international\n" \
      "conventions. All rights are reserved to Estonian Internet Foundation.\n" \
      "Search results may not be used for commercial,advertising, recompilation,\n" \
      "repackaging, redistribution, reuse, obscuring or other similar activities.\n" \
      "Downloading of information about domain names for the creation of your own\n" \
      "database is not permitted. If any of the information from .ee WHOIS is\n" \
      "transferred to a third party, it must be done in its entirety. This server\n" \
      "must not be used as a backend for a search engine.\n" \
      "\n" \
      "Estonia .ee Top Level Domain WHOIS server\n" \
      "\n" \
      "Domain:\n" \
      "name:       privatedomain.test\n" \
      "status:     inactive\n" \
      "registered: 2018-04-25 14:10:41 +03:00\n" \
      "changed:    2018-04-25 14:10:41 +03:00\n" \
      "expire:     2018-07-25\n" \
      "outzone:    \n" \
      "delete:     \n" \
      "\n" \
      "Registrant:\n" \
      "name:       Private Person\n" \
      "email:      Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "changed:    Not Disclosed\n" \
      "\n" \
      "Administrative contact:\n" \
      "name:       Not Disclosed\n" \
      "email:      Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "changed:    Not Disclosed\n" \
      "\n" \
      "Technical contact:\n" \
      "name:       Not Disclosed\n" \
      "email:      Not Disclosed - Visit www.internet.ee for webbased WHOIS\n" \
      "changed:    Not Disclosed\n" \
      "\n" \
      "Registrar:\n" \
      "name:       test\n" \
      "url:        \n" \
      "phone:      \n" \
      "changed:    2018-04-25 14:10:39 +03:00\n" \
      "\n" \
      "\n" \
      "Estonia .ee Top Level Domain WHOIS server\n" \
      "More information at http://internet.ee\n" \
      ""
    end

    assert_equal(text, @private_person_record.unix_body)
  end

  def create_discarded_record
    @discarded_record = WhoisRecord.new(
      name: 'discarded-domain.test',
      json: {
        name: 'discarded-domain.test',
        status: ['deleteCandidate']
      },
      created_at: Date.parse("2018-04-01 11:00 +0300"),
      updated_at: nil
    )
  end

  def create_legal_person_record
    @legal_person_record = WhoisRecord.new(
      name: 'private-domain.test',
      json: {
        admin_contacts: [
          {
            changed: "2018-04-25T14:10:41+03:00",
            email: "admin-contact@companydomain.test",
            name: "Admin Contact"
          }
        ],
        changed: "2018-04-25T14:10:41+03:00",
        delete: nil,
        disclaimer: "The information obtained through .ee WHOIS is subject to database protection according to the Estonian Copyright Act and international conventions. All rights are reserved to Estonian Internet Foundation. Search results may not be used for commercial,advertising, recompilation, repackaging, redistribution, reuse, obscuring or other similar activities. Downloading of information about domain names for the creation of your own database is not permitted. If any of the information from .ee WHOIS is transferred to a third party, it must be done in its entirety. This server must not be used as a backend for a search engine.",
        disclosed: [
          [
            "email",
            "test@test.com"
          ],
          [
            "email",
            "test@test.com"
          ],
          [
            "email",
            "test@test.com"
          ]
        ],
        dnssec_changed: nil,
        dnssec_keys: [

        ],
        email: "owner@companydomain.test",
        expire: "2018-07-25",
        name: "companydomain.test",
        nameservers: [

        ],
        nameservers_changed: nil,
        outzone: nil,
        registered: "2018-04-25T14:10:41+03:00",
        registrant: "test",
        registrant_changed: "2018-04-25T14:10:39+03:00",
        registrant_kind: "org",
        registrant_reg_no: 123,
        registrant_ident_country_code: "EE",
        registrar: "test",
        registrar_address: "test, test, test, test",
        registrar_changed: "2018-04-25T14:10:39+03:00",
        registrar_phone: nil,
        registrar_website: nil,
        status: [
          "inactive"
        ],
        tech_contacts: [
          {
            changed: "2018-04-25T14:10:41+03:00",
            email: "tech-contact@companydomain.test",
            name: "Tech Contact"
          }
        ]
      },
      created_at: Date.parse("2018-04-01 11:00 +0300"),
      updated_at: nil
    )
  end

  def create_private_person_record
    @private_person_record = WhoisRecord.new(
      name: 'private-domain.test',
      json: {
        admin_contacts: [
          {
            changed: "2018-04-25T14:10:41+03:00",
            email: "admin-contact@privatedomain.test",
            name: "Admin Contact"
          }
        ],
        changed: "2018-04-25T14:10:41+03:00",
        delete: nil,
        disclaimer: "The information obtained through .ee WHOIS is subject to database protection according to the Estonian Copyright Act and international conventions. All rights are reserved to Estonian Internet Foundation. Search results may not be used for commercial,advertising, recompilation, repackaging, redistribution, reuse, obscuring or other similar activities. Downloading of information about domain names for the creation of your own database is not permitted. If any of the information from .ee WHOIS is transferred to a third party, it must be done in its entirety. This server must not be used as a backend for a search engine.",
        disclosed: [
          [
            "email",
            "test@test.com"
          ],
          [
            "email",
            "test@test.com"
          ],
          [
            "email",
            "test@test.com"
          ]
        ],
        dnssec_changed: nil,
        dnssec_keys: [

        ],
        email: "owner@privatedomain.test",
        expire: "2018-07-25",
        name: "privatedomain.test",
        nameservers: [

        ],
        nameservers_changed: nil,
        outzone: nil,
        registered: "2018-04-25T14:10:41+03:00",
        registrant: "test",
        registrant_changed: "2018-04-25T14:10:39+03:00",
        registrant_kind: "priv",
        registrar: "test",
        registrar_address: "test, test, test, test",
        registrar_changed: "2018-04-25T14:10:39+03:00",
        registrar_phone: nil,
        registrar_website: nil,
        status: [
          "inactive"
        ],
        tech_contacts: [
          {
            changed: "2018-04-25T14:10:41+03:00",
            email: "tech-contact@privatedomain.test",
            name: "Tech Contact"
          }
        ]
      },
      created_at: Date.parse("2018-04-01 11:00 +0300"),
      updated_at: nil
    )
  end
end
