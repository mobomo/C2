module Ncr
  module Reporter
    def self.total_last_week
      Proposal.where(client_data_type: "Ncr::WorkOrder")
              .where("created_at > ?",1.week.ago).count
    end

    def self.total_unapproved
      Proposal.pending.where(client_data_type: "Ncr::WorkOrder").count
    end

    def self.ba60_proposals
      budget_proposals("BA60", 1.week.ago)
    end

    def self.ba61_proposals
      budget_proposals("BA61", 1.week.ago)
    end

    def self.ba80_proposals
      budget_proposals("BA80", 1.week.ago)
    end

    def self.proposals_pending_approving_official(approval_status = 'actionable')
      # TODO convert to SQL
      Proposal.pending
              .where(client_data_type: 'Ncr::WorkOrder')
              .select{ |p| p.individual_approvals.pluck(:status)[0] == approval_status }
    end

    def self.proposals_pending_budget(approval_status='actionable')
      # TODO convert to SQL
      Proposal.pending
              .where(client_data_type: 'Ncr::WorkOrder')
              .select{ |p| p.individual_approvals.pluck(:status).last == approval_status }
              .sort_by { |pr| pr.client_data.expense_type }
    end

    def self.budget_proposals(type, timespan)
      # TODO convert to SQL
      Proposal.approved
              .where(client_data_type: 'Ncr::WorkOrder')
              .where('created_at > ?', timespan)
              .select { |pr| pr.client_data.expense_type == type }
    end

    def self.proposals_tier_one_pending
      sql = "SELECT * FROM proposals AS p "
      sql += "WHERE p.status='pending' AND p.client_data_type='Ncr::WorkOrder' AND p.client_data_id IN "
      sql += "(SELECT id FROM ncr_work_orders AS nwo WHERE nwo.org_code!=? AND nwo.expense_type IN (?))"
      Proposal.find_by_sql([ sql, Ncr::Organization::WHSC_CODE, %w(BA60 BA61) ])
              .select{ |p| p.individual_approvals.pluck(:status)[1] == 'actionable' }
    end
  end
end
