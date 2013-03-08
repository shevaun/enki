module ApplicationHelper
  def author
    Struct.new(:name, :email).new(enki_config[:author][:name], enki_config[:author][:email])
  end

  def open_id_delegation_link_tags(server, delegate)
    raw links = <<-EOS
      <link rel="openid.server" href="#{server}">
      <link rel="openid.delegate" href="#{delegate}">
    EOS
  end
end
