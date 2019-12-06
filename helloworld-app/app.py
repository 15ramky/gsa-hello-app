from flask import Flask, request, render_template
import socket
import ipaddress

app = Flask(__name__)

#least prefix legth in GCP
LEAST_PREFIX_LENGTH=29

all_ip_subnets = []

def cal_subnets(ipsubnet):
    ipsubnet = ipaddress.IPv4Network(ipsubnet)
    prefix_len = ipsubnet.prefixlen
    if prefix_len == LEAST_PREFIX_LENGTH:
        if ipsubnet not in all_ip_subnets:
            all_ip_subnets.append(ipsubnet)
    else:
        for each_subnet in ipaddress.ip_network(ipsubnet).subnets():
            if each_subnet not in all_ip_subnets:
                all_ip_subnets.append(each_subnet)
            cal_subnets(each_subnet)

@app.route("/", methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/', methods=['POST'])
def my_form_post():
    cal_subnets(request.form['text'])
    result_data = "<br>"
    for each in all_ip_subnets:
        result_data = result_data + " SUBNET: " + each.compressed \
                      + " netmask: " + each.netmask.compressed \
                      + " broadcast address: " + each.broadcast_address.compressed + "<br>"
    html = "<b>All Possible subnets are: </b> {result_data}<br/>"
    return html.format(result_data=result_data)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
