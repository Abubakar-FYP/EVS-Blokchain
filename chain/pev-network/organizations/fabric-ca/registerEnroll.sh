#!/bin/bash

function createPEV1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/PEV1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/PEV1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-PEV1 --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-PEV1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-PEV1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-PEV1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-PEV1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/PEV1.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-PEV1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-PEV1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-PEV1 --id.name PEV1admin --id.secret PEV1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-PEV1 -M ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/msp --csr.hosts peer0.PEV1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-PEV1 -M ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls --enrollment.profile tls --csr.hosts peer0.PEV1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/PEV1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/PEV1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/PEV1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/PEV1.example.com/tlsca/tlsca.PEV1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/PEV1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/peers/peer0.PEV1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/PEV1.example.com/ca/ca.PEV1.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-PEV1 -M ${PWD}/organizations/peerOrganizations/PEV1.example.com/users/User1@PEV1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/PEV1.example.com/users/User1@PEV1.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://PEV1admin:PEV1adminpw@localhost:7054 --caname ca-PEV1 -M ${PWD}/organizations/peerOrganizations/PEV1.example.com/users/Admin@PEV1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/PEV1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/PEV1.example.com/users/Admin@PEV1.example.com/msp/config.yaml
}

function createPEV2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/PEV2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/PEV2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-PEV2 --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-PEV2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-PEV2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-PEV2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-PEV2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/PEV2.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-PEV2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-PEV2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-PEV2 --id.name PEV2admin --id.secret PEV2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-PEV2 -M ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/msp --csr.hosts peer0.PEV2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-PEV2 -M ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls --enrollment.profile tls --csr.hosts peer0.PEV2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/PEV2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/PEV2.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/PEV2.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/PEV2.example.com/tlsca/tlsca.PEV2.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/PEV2.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/peers/peer0.PEV2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/PEV2.example.com/ca/ca.PEV2.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-PEV2 -M ${PWD}/organizations/peerOrganizations/PEV2.example.com/users/User1@PEV2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/PEV2.example.com/users/User1@PEV2.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://PEV2admin:PEV2adminpw@localhost:8054 --caname ca-PEV2 -M ${PWD}/organizations/peerOrganizations/PEV2.example.com/users/Admin@PEV2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/PEV2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/PEV2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/PEV2.example.com/users/Admin@PEV2.example.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
