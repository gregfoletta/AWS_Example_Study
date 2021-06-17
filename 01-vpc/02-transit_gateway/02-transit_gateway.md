---
title: Transit Gateway
author: Greg Foletta
date: 14/6/2021
---

# Basics

## Limitations

Total number of transit gateway attachments is 5000, and the number of transit gateway attachments per VPC is 5.

The maximum bandwidth per VPC is 50 Gbps, and the maximum bandwidth per VPN is 1.25 Gbps.

Maximum of 20 AWS Direct Connect gateways per transit gateway, and three transit gateways per Direct Connect gateway.

## Key Terms

- **Attachment**: attaching or creating a connection between a VPC or VPN to a transit gateway.
- **Association**: associating a route table to an attachment. 
- **Propagation**: propagating the routing into each of the routing tables.

# Setting Up

Consider four VPCs and four domains (non-prod, prod, shared).

Using the transit gateway, we share routing information between the non-prod VPCs 1 & 2, between the two non-prod VPCs 1 & 2 and the shared domain VPC 4, and between the prod VPC 3 and the shared VPC 4. 

Wwe configure static routes to the transit gateway, and a black-hole so that no traffic can move between non-prod and prod.

## Transit Gatway

- DNS support: when resolving DNS entries for other VPCs attached to the transit gateway, when enabled the results will be the private IP addresses, rather than the public IPs.
- Default route propagation: automatically associates and propagates transit gateway attachments with the default route table for the transit gateway.
- Auto accept shared attachments: allow other accounts to automatically attach to the transit gateway.

## Transit Gateway Attachments

Select the transit gateway, then select the VPCs. Need to select the subnets from each availability zone.

Creating separate attachment subnets can give you more routing options, as you can only have one attachment per VPC per availability zone.

# Route Tables

You need to create a route table per attachment.

# Propagation

You create a propagation by selecting a tranit gateway attachment within the transit gataeway route table. If you need to, for instance, have your default out of a shared VPC, the then VPCs need to add a default pointing to the transit gateway. 

# Limitations

VPC published requests to the transit gateway to CloudWatch in 60 second intervals when there is traffic flowing:

- Bytes sent and received
- Packets sent and received
- Packets dropped to a blakchole
- Packets dropped because they didn't have a route

# DirectConnect

