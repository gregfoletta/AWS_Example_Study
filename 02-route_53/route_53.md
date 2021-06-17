---
title: AWS Networking - Route 53 Basics
author: Greg Foletta
date: 11/6/2021
---

# Basics

DNS server, provides health checks to ensure availability. Can receive notification when something becomes unavailable.

- Performance - global anycast network, low query latency.
- Scalable - automatically scales to handle large query volumes without intervention.
- AWS Integration
    - Intergrates with IAM to grant unique permissions, map domains to EC2, S3, Cloudfront and other AWS resources.
    - Map to ELB instances using *alias* record.
- Ease of use - self service sign-up.
- Only pay for managing domains and queries the service answers. No minimum or upfront fees
- Flexibility - weighted routing policy, geolocation routing policy.

Major components:

- Domain registration - register or transfer
- Domain hosting - hosted zones for domains, authoritative nameservers.
- Health checks - monitor applications and web resources.
- Resolver - previous VPC DNS, customers automatically get DNS resolution within the VPC. By default answers recursive as well as Route 53 private hosted domains.

# Domain Registration Roles

- **Registrant** - buy domains from reseller or registrar.
- **Reseller** - provide doamin name registration services, transfer registration.
- **Registrar** - interfaces between a registrant, and a registry.
- **Registry** - maintains the authoritative nameservers and hosted zones for one or more top-level domains.

# Hosted Zones

Two types of zones, **public** and **private** zones. Each public hosted zone gets four name servers. 

You can have a single private hosted zone associated with multiple VPCs, or multiple private hosted zones associated to share the same VPC.

# Private Hosted Zones

There are some consideration when using private hosted zones:

## VPC

VPC settings *enableDnsHostname* and *enableDnsSupport* need to be set to true. Only the Route 53 resolver can resolve records, and any resource wihtin a VPC can use resolver for public and private domain names

## Health Checks

Health checks can only be associated with failover, multivalue answer, and weighted records.

## Routing Policies

You can use simple, failover, multivalue answer and weighted. Other routing values are not supported.

## Split-View DNS

Maintain internal and external version, configure public and private zones to return different internal and external and external IP addresses for the same domain name.

## Amazon V

Associate private hosted zones with the same VPC even if they have overnapping namespaces. e.g. Central team manages example.com, but independent teams manage subdomains of that zone (a.example.com and b.example.com)

## Overlapping Namespaces

Match is defined as:

- And identical match
- Private hosted zone is a parent of the domain name in the request

If there is no private hosted zone, EC2 forwards the requests to a public DNS resolver. If there is a private  hosted zone that matches the domain name is the request, query searches the hosted zone for the record that matches the domain name and DNS type. 

If the private hosted zone matches, but no record matches, EC2 doesn't forward on to a public resolver.

## Delegation

Not possible to create NS records in a private hosted zone to delegat responsibility for a subdomain.

# Alias Records

Alias records are mapped internally to the DNS name of alias targets such as AWS resources. R53 monitors the IP address associated with an alias targets DNS name for scaling actions and software updates.

- Requires the same type as the target record.
- Unlike CNAME, alias records can create records for the zone apex, e.g. in an 'example.com' zone, you **can** create an alias for 'example.com'.
- Map domain name to
    - Supported AWS services
    - Record of same type within hosted zone

R53 automatically recognised changes in resource. For example if an alias record pointed towards an ELB. If the IP of the ELB changes, the alias record updates as well.

Can't configure the TTL value for alias records. The TTL assumes the value of the resource it's pointing to.

Queries for alias records are not charged.

You can point to the following resources:

- CloudFront distribution A or AAAA records.
- Eastic beanstalk A record
- ELB A or AAAA record
- S3 bucked A record
- API gateway custom regional API and edge optimised API A record.
- VPC interface endpoint A record
- AWS global accelerator A record
- Another R43 record in the same hosted zone.

# CNAME Records

R53 follows the pointer in an alias record only if the record type matches

- You can't create CNAME records for the zone apex.
- They dont support change detection
- It is possible to configure custom TTL value
- Queries are billed at current AWS pricing

# Health Checks

Three types of health checks

- Monitor endpoint - creatch a TCP, HTTP, or HTTPS health check.
- Monitor other health checks - can do 'OR' or 'AND' 
- Monitor CloudWatch alarms

# Routing Policy

- Simple: single resource
- Failover: active/passive failover based on a health check
- Geolocation: route traffic based on the location of the request
- Geoproximity: route based on the location of the resources - and optionally - shift traffic from resources in one location to one in another
- Latency: resources in multiple locations, route to the region that provides the best latency.
- Multivalue answer: respond to records with up to eight healthy records selected at random.
- Weighted: route to multiple resources based on proportions.
