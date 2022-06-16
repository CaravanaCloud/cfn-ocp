# OpenShift::OCP::Cluster

An example resource schema demonstrating some basic constructs and validation rules.

## Syntax

To declare this entity in your AWS CloudFormation template, use the following syntax:

### JSON

<pre>
{
    "Type" : "OpenShift::OCP::Cluster",
    "Properties" : {
        "<a href="#clustername" title="ClusterName">ClusterName</a>" : <i>String</i>
    }
}
</pre>

### YAML

<pre>
Type: OpenShift::OCP::Cluster
Properties:
    <a href="#clustername" title="ClusterName">ClusterName</a>: <i>String</i>
</pre>

## Properties

#### ClusterName

OpenShift Cluster Name

_Required_: Yes

_Type_: String

_Pattern_: <code>^[A-Z]{3,5}[0-9]{8}-[0-9]{4}$</code>

_Update requires_: [No interruption](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-update-behaviors.html#update-no-interrupt)

## Return Values

### Ref

When you pass the logical ID of this resource to the intrinsic `Ref` function, Ref returns the ClusterName.
