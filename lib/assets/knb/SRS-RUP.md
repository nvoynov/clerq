% Software Requirement Specification

_[Text enclosed in square brackets and displayed in italics is included to provide guidance to the author and should be deleted before publishing the document.]_

# 1. Introduction
_[The introduction of the Software Requirements Specification (SRS) provides an overview of the entire SRS. It includes the purpose, scope, definitions, acronyms, abbreviations, references, and overview of the SRS.]_

_[**Note**: The SRS document captures the complete software requirements for the system, or a portion of the system.  Following is a typical SRS outline for a project using traditional, natural-language style requirements. It captures all requirements in a single document.]_

## 1.1 Purpose
_[Specify the purpose of this SRS. The SRS fully describes the external behavior of the application or subsystem identified. It also describes nonfunctional requirements, design constraints, and other factors necessary to provide a complete and comprehensive description of the requirements for the software.]_

## 1.2 Scope
_[A brief description of the software application that the SRS applies to, the feature or other subsystem grouping, and anything else that is affected or influenced by this document.]_

## 1.3 Definitions, Acronyms, and Abbreviations
_[This subsection provides the definitions of all terms, acronyms, and abbreviations required to properly interpret the SRS.  This information may be provided by reference to the project’s Glossary.]_

| Term           | Definition     |
| :------------- | :------------- |
| Item One       | Item Two       |

## 1.4 References
_[This subsection provides a complete list of all documents referenced elsewhere in the SRS.  Identify each document by title, report number if applicable, date, and publishing organization.  Specify the sources from which the references can be obtained. This information may be provided by reference to an appendix or to another document
Among other references should include following documents (if applicable):
 •	Product Requirements Document;
 •	Project Estimation Sheet;
 •	Risk Management Plan.]
[In this subsection:
1) Provide a complete list of all documents referenced elsewhere in the SRS.
2) Identify each document by title, report number  (if applicable), date, and publishing organization.
3) Specify the sources from which the references can be obtained.]_

## 1.5 Overview
_[This subsection describes what the rest of the SRS contains and explains how the document is organized.]_

# 2. Overall Description
_[This section of the SRS describes the general factors that affect the product and its requirements.  This section does not state specific requirements.  Instead, it provides a background for those requirements, which are defined in detail in Section 3, and makes them easier to understand. Include such items as bellow]_

## 2.1 Product perspective
_[This subsection of the SRS relates the product to other products or projects.
1) If the product is independent and totally self-contained, it should be stated here.
2) If the SRS defines a product that is a component of a larger system or project:
	a) Describe the functions of each component of the larger system or project, and identify interfaces
	b) Identify the principal external interfaces of this software product (not a detailed description)
	c) Describe the computer hardware and peripheral equipment to be used (overview only).]
A block diagram showing the major components of the larger system or project, interconnections, and external interfaces can be very helpful]._

## 2.2 Product functions
_[Provide a summary of the functions that the software will perform. Sometimes the function summary that is necessary for this part can be taken directly from the section of the higher-level specification (if one exists) that allocates particular functions to the software product.  The functions should be organized in a way that makes the list of functions understandable to the customer or to anyone else reading the document for the first time.  Block diagrams showing the different functions and their relationships can be helpful.  Such a diagram is not a requirement on the design of a product itself; it is simply an effective explanatory tool.]_

## 2.3 User characteristics
_[Describe those general characteristics of the eventual users of the product that will affect the specific requirements._

_Many people interact with a system during the operation and maintenance phase of the software life cycle.  Some of these people are users, operators, and maintenance and systems personnel.  Certain characteristics of these people, such as educational level, experience, and technical expertise impose important constraints on the system's operating environment.]_

## 2.4 Constraints
_[Provide a general description of any other items that will limit the developer's options for designing the system.  These can include:
1) Regulatory policies
2) Hardware limitations; for example, signal timing requirements
3) Interface to other applications
4) Parallel operation
5) Audit functions
6) Control functions
7) Higher-order language requirements
8) Signal handshake protocols; for example, XON-XOFF, ACK-NACK.
9) Criticality of the application.
10) Safety and security considerations]_

## 2.5 Assumptions and dependencies
_[List and describe each of the factors that affect the requirements stated in the SRS.  These factors are not design constraints on the software but any changes to them can affect the requirements in the SRS.  For example, an assumption might be that a specific operating system will be available on the hardware designated for the software product.  If, in fact, the operating system is not available, the SRS would then have to change.]_

## 2.6 Requirements subsets
_[Grouping of requirements are listed in this subsection.]_

## 2.7 General Requirements
_[List and describe all general requirements that affect the process and conditions of product development. General requirements are non-specific, non-technical requirements and concern first of all constraints imposed by customer on project development. Examples of such a requirements are:
1) Deadlines for product releases deliveries defined in advance.
2) Number and skills of intended Project Team.
3) Amount of efforts allocated to project phase/activity (e.g. for product testing).
These kinds of requirements should be listed in this section or reference to another document, which includes such a requirements, should be provided here (e.g. to Project Scope Definition).]_

## 2.8 Use-Case Model
_[If using use-case modeling, this section contains an overview of the use-case model or the subset of the use-case model that is applicable for this subsystem or feature.  This includes a list of names and brief descriptions of all use cases and actors, along with applicable diagrams and relationships.]_

# 3. Specific Requirements
_[This section of the SRS contains all software requirements to a level of detail sufficient to enable designers to design a system to satisfy those requirements, and testers to test that the system satisfies those requirements. When using use-case modeling, these requirements are captured in the Use Cases and the applicable supplementary specifications.  If use-case modeling is not used, the outline for supplementary specifications may be inserted directly into this section, as shown below.]_

_[In use-case modeling, the use cases often define the majority of the functional requirements of the system, along with some non-functional requirements. For each use case in the above use-case model, or subset thereof, refer to, or enclose, the use-case report in this section. Make sure that each requirement is clearly labeled.]_

## 3.1 Functionality
_[This section describes the functional requirements of the system for those requirements that are expressed in the natural language style. For many applications, this may constitute the bulk of the SRS package and thought should be given to the organization of this section. This section is typically organized by feature, but alternative organization methods may also be appropriate; for example, organization by user or organization by subsystem. Functional requirements may include feature sets, capabilities, and security.
Where application development tools, such as requirements tools, modeling tools, and the like, are employed to capture the functionality, this section of the document would refer to the availability of that data, indicating the location and name of the tool used to capture the data.]
Functionality — the capability of the software product to provide functions which meet stated and implied needs when the software is used under specified conditions.
This characteristic is concerned with what the software does to fulfill needs, whereas the other characteristics are mainly concerned with when and how it fulfils needs.

Functionality includes:
1) Suitability — the capability of the software product to provide an appropriate set of functions for specified tasks and user objectives.
Examples of appropriateness are task-oriented composition of functions from constituent sub-functions, and capacities of tables.
2) Accuracy — the capability of the software product to provide the right or agreed results or effects with the needed degree of precision.
3) Interoperability — the capability of the software product to interact with one or more specified systems.
4) Security — the capability of the software product to protect information and data so that unauthorized persons or systems cannot read or modify them and authorized persons or systems are not denied access to
5) Functionality compliance — the capability of the software product to adhere to standards, conventions or regulations in laws and similar prescriptions relating to functionality.]_

### 3.1.1	Functional Requirement One
_[For each function, specify requirements on inputs, processing, and outputs. These are usually organized with these four subparagraphs:
1) Purpose of the function:  Provide rationale to clarify the intent of the function.
2) Inputs:  sources, valid ranges of values, any timing concerns, operator requirements, special interfaces
3) Operations to be performed: validity checks, responses to abnormal conditions, types of processing required
4) Outputs: destinations, valid ranges of values, timing concerns, handling of illegal values, error messages, interfaces required
For example, the following might be an example specification.  Depending on the level of tracking required by the project, one might trace each of the components of 3.1.1.1 as separate requirements, or one might trace just 3.1.1.1.  Note that the level of detail here tells what needs to be accomplished against what specific goals, but it does not specify how that is to be done.
3.1.1 Provider Terminal  (PT) Functional Requirements
   3.1.1.1 Signature Verification
Purpose:  The PT shall have a signature recognition system that can be used to authenticate users of the ChocAn membership services.
Inputs: Members sign their name once when applying for membership.  Each authentication effort  done when a service is requested should take no more than one signature by the member.
Processing: Handling of the authorization should take no more than 5 seconds.
Outputs: If the match is successful, a positive acknowledgment must come to the member at the signature capture device as well as to the PT.  If the match is unsuccessful, an appropriate message to that effect must be provided to both the capture device and the PT.]_

## 3.2 Quality Requirements

### 3.2.1 Reliability
_[The capability of the software product to maintain a specified level of performance when used under specified conditions.
[Requirements for reliability of the system should be specified here. Some suggestions follow:
•	Availability—specify the percentage of time available ( xx.xx%), hours of use, maintenance access, degraded mode operations, and so on.
•	Mean Time Between Failures (MTBF) — this is usually specified in hours, but it could also be specified in terms of days, months or years.
•	Mean Time To Repair (MTTR)—how long is the system allowed to be out of operation after it has failed?
•	Accuracy—specifies precision (resolution) and accuracy (by some known standard) that is required in the system’s output.
•	Maximum Bugs or Defect Rate—usually expressed in terms of bugs per thousand lines of code (bugs/KLOC) or bugs per function-point( bugs/function-point).
•	Bugs or Defect Rate—categorized in terms of minor, significant, and critical bugs: the requirement(s) must define what is meant by a “critical” bug; for example, complete loss of data or a complete inability to use certain parts of the system’s functionality.]_

#### 3.2.1.1 Maturity
_[The capability of the software product to avoid failure as a result of faults in the software.]_

#### 3.2.1.2 Fault tolerance
_[The capability of the software product to maintain a specified level of performance in cases of software faults or of infringement of its specified interface. The specified level of performance may include fail safe capability.]_

#### 3.2.1.3 Recoverability
_[The capability of the software product to re-establish a specified level of performance and recover the data directly affected in the case of a failure.
Following a failure, a software product will sometimes be down for a certain period of time, the length of which is assessed by its recoverability.
**Availability** is the capability of the software product to be in a state to perform a required function at a given point in time, under stated conditions of use. Externally, availability can be assessed by the proportion of total time during which the software product is in an up state. Availability is therefore a combination of maturity (which governs the frequency of failure), fault tolerance and recoverability (which governs the length of down time following each failure). For this reason it has not been included as a separate sub-characteristic.]_

#### 3.2.1.4 Reliability compliance
_[The capability of the software product to adhere to standards, conventions or regulations relating to reliability.]_

### 3.2.2 Usability
_[The capability of the software product to be understood, learned, used and attractive to the user, when used under specified conditions.
This section includes all those requirements that affect usability. For example,
•	specify the required training time for a normal users and a power user to become productive at particular operations
•	specify measurable task times for typical tasks or base the new system’s usability requirements on other systems that the users know and like
•	specify requirement to conform to common usability standards, such as IBM’s CUA standards Microsoft’s GUI standards]
Users may include operators, end users and indirect users who are under the influence of or dependent on the use of the software. Usability should address all of the different user environments that the software may affect, which may include preparation for usage and evaluation of results.]_

#### 3.2.2.1 Understandability
_[The capability of the software product to enable the user to understand whether the software is suitable, and how it can be used for particular tasks and conditions of use. This will depend on the documentation and initial impressions given by the software.]_

#### 3.2.2.2 Learnability
_[The capability of the software product to enable the user to learn its application.]_

#### 3.2.2.3 Operability
_[The capability of the software product to enable the user to operate and control it. Aspects of suitability, changeability, adaptability and installability may affect operability.
For a system which is operated by a user, the combination of functionality, reliability, usability and efficiency can be measured externally by quality in use.]_

#### 3.2.2.4 Attractiveness
_[The capability of the software product to be attractive to the user. This refers to attributes of the software intended to make the software more attractive to the user, such as the use of color and the nature of the graphical design.]_

#### 3.2.2.5 Usability compliance
_[The capability of the software product to adhere to standards, conventions, style guides or regulations relating to usability.]_

### 3.2.3 Efficiency
_[The capability of the software product to provide appropriate performance, relative to the amount of resources used, under stated conditions.
Resources may include other software products, the software and hardware configuration of the system, and materials (e.g. print paper, diskettes).
For a system which is operated by a user, the combination of functionality, reliability, usability and efficiency can be measured externally by quality in use.]_

#### 3.2.3.1 Time behavior
_[The capability of the software product to provide appropriate response and processing times and throughput rates when performing its function, under stated conditions.]_

#### 3.2.3.2 Resource utilization
_[The capability of the software product to use appropriate amounts and types of resources when the software performs its function under stated conditions.
Human resources are included as part of productivity.]_

#### 3.2.3.3 Efficiency compliance
_[The capability of the software product to adhere to standards or conventions relating to efficiency.]_

#### 3.2.3.4 Maintainability
_[The capability of the software product to be modified. Modifications may include corrections, improvements or adaptation of the software to changes in environment, and in requirements and functional specifications.]_

#### 3.2.3.5 Analyzability
_[The capability of the software product to be diagnosed for deficiencies or causes of failures in the software, or for the parts to be modified to be identified.]_

#### 3.2.3.6 Changeability
_[The capability of the software product to enable a specified modification to be implemented.
Implementation includes coding, designing and documenting changes.
If the software is to be modified by the end user, changeability may affect operability.]_

#### 3.2.3.7 Stability
_[The capability of the software product to avoid unexpected effects from modifications of the software.]_

#### 3.2.3.8 Testability
_[The capability of the software product to enable modified software to be validated.]_

#### 3.2.3.9 Maintainability compliance
_[The capability of the software product to adhere to standards or conventions relating to maintainability.]_

### 3.2.4 Portability
_[The capability of the software product to be transferred from one environment to another.
The environment may include organizational, hardware or software environment.]_

#### 3.2.4.1 Adaptability
_[The capability of the software product to be adapted for different specified environments without applying actions or means other than those provided for this purpose for the software considered.
 Adaptability includes the scalability of internal capacity (e.g. screen fields, tables, transaction volumes, report formats, etc.).
If the software is to be adapted by the end user, adaptability corresponds to suitability for individualization, and may affect operability.]_

#### 3.2.4.2 Installability
_[The capability of the software product to be installed in a specified environment.
If the software is to be installed by an end user, installability can affect the resulting suitability and
operability.]_

#### 3.2.4.3 Co-existence
_[The capability of the software product to co-exist with other independent software in a common environment sharing common resources.]_

#### 3.2.4.4 Replaceability
_[The capability of the software product to be used in place of another specified software product for the same purpose in the same environment.
For example, the replaceability of a new version of a software product is important to the user when upgrading.
Replaceability is used in place of compatibility in order to avoid possible ambiguity with interoperability.
Replaceability may include attributes of both installability and adaptability. The concept has been introduced as a subcharacteristic of its own because of its importance.]_

#### 3.2.4.5 Portability compliance
_[The capability of the software product to adhere to standards or conventions relating to portability.]_

## 3.3 Design Constraints
_[This section indicates any design constraints on the system being built. Design constraints represent design decisions that have been mandated and must be adhered to.  Examples include software languages, software process requirements, prescribed use of developmental tools, architectural and design constraints, purchased components, class libraries, and so on.
1) Standards Compliance.
•	Specify the requirements derived from existing standards or regulations.  They might include:
•	Report format
•	Data naming
•	Accounting procedures
•	Audit Tracing.  For example, this could specify the requirement for software to trace processing activity.  Such traces are needed for some applications to meet minimum government or financial standards.  An audit trace requirement might, for example, state that all changes to a payroll data base must be recorded in a trace file with before and after values.
2)  Hardware Limitations.
Identify the requirements for the software to operate inside various hardware constraints.]_

### 3.3.1 Design Constraint One
_[The requirement description goes here.]_

## 3.4 On-line User Documentation and Help System Requirements
_[Describes the requirements, if any, for o-line user documentation, help systems, help about notices, and so forth.]_

## 3.5 Purchased Components
_[This section describes any purchased components to be used with the system, any applicable licensing or usage restrictions, and any associated compatibility and interoperability or interface standards.]_

## 3.6 Interfaces
_[This section defines the interfaces that must be supported by the application. It should contain adequate specificity, protocols, ports and logical addresses, and the like, so that the software can be developed and verified against the interface requirements.]_

### 3.6.1 User Interfaces
_[Describe the user interfaces that are to be implemented by the software.]_

### 3.6.2 Hardware Interfaces
_[This section defines any hardware interfaces that are to be supported by the software, including logical structure, physical addresses, expected behavior, and so on.]_

### 3.6.3 Software Interfaces
_[This section describes software interfaces to other components of the software system. These may be purchased components, components reused from another application or components being developed for subsystems outside of the scope of this SRS but with which this software application must interact.]_

### 3.6.4 Communications Interfaces
_[Describe any communications interfaces to other systems or devices such as local area networks, remote serial devices, and so forth.]_

## 3.7 Licensing Requirements
_[Defines any licensing enforcement requirements or other usage restriction requirements that are to be exhibited by the software.]_

## 3.8 Legal, Copyright, and Other Notices
_[This section describes any necessary legal disclaimers, warranties, copyright notices, patent notices, wordmark, trademark, or logo compliance issues for the software.]_

## 3.9 Applicable Standards
_[This section describes by reference any applicable standard and the specific sections of any such standards which apply to the system being described. For example, this could include legal, quality and regulatory standards, industry standards for usability, interoperability, internationalization, operating system compliance, and so forth.]_

# 4. Supporting Information
_[The supporting information makes the SRS easier to use.  It includes:
The supporting information; that is, the Table of Contents, the Appendices, and the Index, make the SRS easier to use.  The Appendices are not always considered part of the actual requirements specification and are not always necessary.  They might include:
a)  Sample I/O formats, descriptions of cost analysis studies, results of user surveys.
b)  Supporting or background information that can help the readers of the SRS.
c)  A description of the problems to be solved by the software.
d)  The history, background, experience and operational characteristics of the organization to be supported.
e)  A cross-reference list, arranged by milestone, of those incomplete software requirements that are to be completed by specified milestones.
f)  Special packaging instructions for the code and the media to meet security, export, initial loading, or other requirements.
When Appendices are included, the SRS should explicitly state whether or not the Appendices are to be considered part of the requirements.]_
