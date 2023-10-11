# hashicorp-consul
A high-availability Hashicorp Consul deployment for Docker Swarm

## Getting Started

You should only have Consul deployed once per Docker Swarm Cluster.

You will need to create swarm-scoped overlay network called `consul_area_lan` for services to communicate if you haven't already.

```sh
docker network create --scope=swarm --driver=overlay --attachable consul_area_lan
```

We provided a base configuration file for Consul. You can find it in the `config` folder.  
Please make a copy as `configs/config.hcl`, and edit it to your needs.

## How it works

The Consul cluster is deployed as a Docker Swarm service. Its leverages the `ingress` network for forming the cluster.

![Consul Architecture](https://content.hashicorp.com/api/assets?product=consul&version=refs%2Fheads%2Frelease%2F1.16.x&asset=website%2Fpublic%2Fimg%2Fconsul-arch%2Fconsul-arch-overview-control-plane.svg&width=960&height=540)
> See https://developer.hashicorp.com/consul/docs/architecture for more information

### Server placement

A `node.labels.consul` label is used to determine which nodes the service can be deployed on.

The deployment uses both placement **constraints** & **preferences** to ensure that the servers are spread evenly across the Docker Swarm manager nodes and only **ALLOW** one replica per node.

![placement_prefs](https://docs.docker.com/engine/swarm/images/placement_prefs.png)

> See https://docs.docker.com/engine/swarm/services/#control-service-placement for more information.

#### List the nodes
On the manager node, run the following command to list the nodes in the cluster.

```sh
docker node ls
```

#### Add the label to the node
On the manager node, run the following command to add the label to the node.

Repeat this step for each node you want to deploy the service to. Make sure that the number of node updated matches the number of replicas you want to deploy.

**Example deploy service with 3 replicas**:
```sh
docker node update --label-add consul=true <node-1>
docker node update --label-add consul=true <node-2>
docker node update --label-add consul=true <node-3>
```

## Fault Tolerance
Fault tolerance is the ability of a system to continue operating without interruption despite the failure of one or more components. The most basic production deployment of Consul has 3 server agents and can lose a single server without interruption.

As you continue to use Consul, your circumstances may change. Perhaps a datacenter becomes more business critical or risk management policies change, necessitating an increase in fault tolerance. The sections below discuss options for how to improve Consul's fault tolerance.

## Fault Tolerance in Consul
Consul's fault tolerance is determined by the configuration of its voting server agents.

Each Consul datacenter depends on a set of Consul voting server agents. The voting servers ensure Consul has a consistent, fault-tolerant state by requiring a majority of voting servers, known as a quorum, to agree upon any state changes. Examples of state changes include: adding or removing services, adding or removing nodes, and changes in service or node health status.

Without a quorum, Consul experiences an outage: it cannot provide most of its capabilities because they rely on the availability of this state information. If Consul has an outage, normal operation can be restored by following the [Disaster recovery for Consul clusters guide](https://developer.hashicorp.com/consul/tutorials/datacenter-operations/recovery-outage).

If Consul is deployed with 3 servers, the quorum size is 2. The deployment can lose 1 server and still maintain quorum, so it has a fault tolerance of 1. If Consul is instead deployed with 5 servers, the quorum size increases to 3, so the fault tolerance increases to 2. To learn more about the relationship between the number of servers, quorum, and fault tolerance, refer to the [consensus protocol documentation](https://developer.hashicorp.com/consul/docs/architecture/consensus#deployment_table).

Effectively mitigating your risk is more nuanced than just increasing the fault tolerance metric described above. You must consider:

### Add More Voting Servers
most production use cases, we recommend using either 3 or 5 voting servers, yielding a server-level fault tolerance of 1 or 2 respectively.

Even though it would improve fault tolerance, adding voting servers beyond 5 is not recommended because it decreases Consul's performance— it requires Consul to involve more servers in every state change or consistent read.

If you want to change the number of replicas, you can do so by changing by set the `CONSUL_REPLICAS` environment value to your desire value, e.g.: `CONSUL_REPLICAS=5`.

## Deployment

To deploy the stack, run the following command:

```sh
$ make deploy
```

## Destroy

To destroy the stack, run the following command:

```sh
$ make destroy
```
