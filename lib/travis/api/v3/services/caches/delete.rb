module Travis::API::V3
  class Services::Caches::Delete < Service
    def run!
      raise LoginRequired unless access_control.logged_in? or access_control.full_access?
      caches = query.find(find(:repository))
      access_control.permissions(:repository).delete!
      caches.destroy_all
    end
  end
end
