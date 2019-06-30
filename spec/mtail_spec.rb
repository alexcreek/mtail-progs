require 'json'

module Helpers
  def mtail(prog, logfile)
    out = `mtail -one_shot -progs #{prog} -logs spec/#{logfile}`
    stripped = out.delete_prefix("Metrics store:")
    JSON.parse(stripped)
  end
end

RSpec.configure do |config|
  config.include(Helpers)
end

describe 'nginx 1.16 default main' do
  it 'parses http_requests_total' do
    data = mtail('nginx.mtail', 'nginx.log')
    total = 0
    data['http_requests_total'][0]['LabelValues'].each do |i|
      total += i['Value']['Value']
    end
    expect(total).to eq(6)
  end
  it 'parses http_client_errors_total' do
    data = mtail('nginx.mtail', 'nginx.log')
    total = data['http_client_errors_total'][0]['LabelValues'][0]['Value']['Value']
    expect(total).to eq(2)
  end
  it 'parses http_server_errors_total' do
    data = mtail('nginx.mtail', 'nginx.log')
    total = data['http_server_errors_total'][0]['LabelValues'][0]['Value']['Value']
    expect(total).to eq(2)
  end
end
