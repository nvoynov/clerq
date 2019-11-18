% Requirements attributes

# User metrics

* `rationale` a justification
* `originator` who raised
* `fit criterion` is it possible to test if the solution matches the requirement
* `customer satisfaction` degree of the stakeholders happiness if this requirement is successfully implemented; 1-5, uninterested - extremely pleased.
* `customer dissatisfaction` measure of stakeholders unhappiness if this requirements is not part of the final product. 1-5, hardly matters - extremely displeased.
* `conflict` other requirements that cannot be implemented if the one is

# Estimation metrics

* `complexity`
* `effort`
* `risk`
* `priority`

# Traceability

* `derive` relationship between two requirements, used when a requirement is derived from another requirement. This type of relationship is appropriate to link the requirements on different levels of abstraction. For example, a solution requirement derived from a business or a stakeholder requirement.
* `depends` relationship between two requirements, used when a requirement depends on another requirement. Types of dependency relationships include:
   * `necessity` when it only makes sense to implement a particular requirement if a related requirement is also implemented.
   * `effort`: when a requirement is easier to implement if a related requirement is also implemented.
* `satisfy` relationship between an implementation element and the requirements it is satisfying. For example, the relationship between a functional requirement and a solution component that is implementing it.
* `validate` relationship between a requirement and a test case or other element that can determine whether a solution fulfills the requirement.
