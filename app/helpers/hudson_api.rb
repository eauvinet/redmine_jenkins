# -*- coding: utf-8 -*-
#
require "uri"
require 'net/http'

class HudsonApi

  def self.get_job_list(hudson_url, auth_user, auth_password)
    url = "#{hudson_url}/xml?depth=0"

    HudsonApi.new.open url, auth_user, auth_password
  end

  def self.get_job_details(hudson_url, auth_user, auth_password)
    url = "#{hudson_url}/xml?depth=1"
    url << "&xpath=/hudson"
    url << "&exclude=/hudson/view"
    url << "&exclude=/hudson/primaryView"
    url << "&exclude=/hudson/job/build"
    url << "&exclude=/hudson/job/lastCompletedBuild"
    url << "&exclude=/hudson/job/lastStableBuild"
    url << "&exclude=/hudson/job/lastSuccessfulBuild"

    HudsonApi.new.open url, auth_user, auth_password
  end

  def self.get_build_results(hudson_url, auth_user, auth_password)
    url = "#{hudson_url}/xml/?depth=1"
    url << "&exclude=//build/changeSet/item/path"
    url << "&exclude=//build/changeSet/item/addedPath"
    url << "&exclude=//build/changeSet/item/modifiedPath"
    url << "&exclude=//build/changeSet/item/deletedPath"
    url << "&exclude=//build/culprit"
    url << "&exclude=//module"
    url << "&exclude=//firstBuild&exclude=//lastBuild"
    url << "&exclude=//lastCompletedBuild"
    url << "&exclude=//lastFailedBuild"
    url << "&exclude=//lastStableBuild"
    url << "&exclude=//lastSuccessfulBuild"
    url << "&exclude=//downstreamProject"
    url << "&exclude=//upstreamProject"

    HudsonApi.new.open url, auth_user, auth_password
  end

  def open(uri, auth_user, auth_password)

    begin
      http = create_http_connection(uri)
      request = create_http_request(uri, auth_user, auth_password)
    rescue => error
      raise HudsonApiException.new(error)
    end

    begin
      response = http.request(request)
    rescue Timeout::Error, StandardError => error
      raise HudsonApiException.new(error)
    end

    case response
    when Net::HTTPSuccess, Net::HTTPFound
      return response.body
    else
      raise HudsonApiException.new(response)
    end
  end

  def create_http_connection(uri)

    param = URI.parse( URI.escape(uri) )

    if "https" == param.scheme then
      param.port = 443 if param.port == nil || param.port == ""
    end

    retval = Net::HTTP.new(param.host, param.port)

    if "https" == param.scheme then
      retval.use_ssl = true
      retval.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    return retval

  end

  def create_http_request(uri, auth_user, auth_password)
    
    param = URI.parse( URI.escape(uri) )

    getpath = param.path
    getpath += "?" + param.query if param.query != nil && param.query.length > 0

    retval = Net::HTTP::Get.new(getpath)
    retval.basic_auth(auth_user, auth_password) if auth_user != nil && auth_user.length > 0

    return retval

  end
  
end
