import * as cdk from 'aws-cdk-lib'
import ec2 = require('aws-cdk-lib/aws-ec2'); 

export class Ec2T2MicroStack extends cdk.Stack {

    constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
      super(scope, id, props);

    // define AWS virtual private cloud
    const vpc = new ec2.Vpc(this, 'Ec2T2Micro-VPC');

    // define AWS security group for vpc above
    const securityGroup = new ec2.SecurityGroup(this, 'Ec2T2MicroSecurityGroup', {
      vpc,
      securityGroupName: "Ec2T2Micro-SG",
      description: 'Allow ssh access to ec2 instances from anywhere',
      allowAllOutbound: true 
    });

    // allow only SSH connection from anywhere
    securityGroup.addIngressRule(
      ec2.Peer.anyIpv4(), 
      ec2.Port.tcp(22), 
      'allow public ssh access'
    )

    // actual AWS EC2 instance specification
    const linux = new ec2.AmazonLinuxImage({
      generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX,
      edition: ec2.AmazonLinuxEdition.STANDARD,
      virtualization: ec2.AmazonLinuxVirt.HVM,
      storage: ec2.AmazonLinuxStorage.GENERAL_PURPOSE,
    });

    // this creates the actual instance in AWS, NOTE check costs!!!
    new ec2.Instance(this, 'Ec2T2MicroInstance', {
      vpc,
      machineImage: linux,
      instanceName: 'ec2t2microinstancename',
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T2, ec2.InstanceSize.MICRO),

    })

  }
}