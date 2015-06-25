module CommunicartMailerHelper
  def status_icon_tag(status, linear=false)
    bg_linear_image = root_url.gsub(/\?.*$/,'').chomp("/")+image_path("bg_#{status}_status.gif")

    image_tag(root_url.gsub(/\?.*$/,'').chomp("/")+image_path("icon-#{status}.png"),
              class: "status-icon #{status} #{'linear' if linear}",
              style: "background-image: url('#{bg_linear_image}');"
    )

  end

  def generate_bookend_class(index, count)
    case index
    when count - 1
      'class=last'
    when 0
      'class=first'
    else
      ''
    end
  end

  def generate_approve_url(approval)
    proposal = approval.proposal
    opts = { version: proposal.version, cch: approval.api_token.access_token }
    approve_proposal_url(proposal, opts)
  end
end
