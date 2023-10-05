# hashicorp-consul
A high-availability Hashicorp Consul deployment for Docker Swarm

![Consul Architecture](https://github.com/YouMightNotNeedKubernetes/hashicorp-consul/assets/4363857/8219e0ac-5bbf-4cb9-9649-b01fbfe824b8)

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
