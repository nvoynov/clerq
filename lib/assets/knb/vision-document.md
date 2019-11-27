% Vision Document Template
Company Name
Vision Document for [Program Name]
(r) 20XX [Company Name]

# Revision History

Date | Revision | Description | Author
:--- | :------- | :---------- | :-----
mm/dd/yy | 1.0 | Initial version | Author name

# Table of Contents

# 1 Introduction

This section provides an overview of the Vision document.

## 1.1 Purpose

This document defines the strategic intent of the program. It defines high-level user needs, any applicable user personas, key stakeholders, and the general system capabilities needed by the users.

## 1.2 Solution Overview

State the general purpose of the product, system, application or service, and any version identification.

* Identify the product or application to be created or enhanced.
* Describe the application of the product, including its benefits, goals, and objectives.
* Provide a general description of what the solution will and, where appropriate, will not do.

## 1.3 References

List other documents referenced, and specify the sources from which the references can be obtained. If a business case (Chapter 23) was developed to drive the program, refer to it or attach it.

# 2 User Description
To provide products and services that meet users’ needs, it is helpful to understand the challenges they confront when performing their jobs. This section should profile the intended users of the application and the key problems that limit the user’s productivity. This section should not be used to state specific requirements; just provide the background for why the features specified in Section 5 are needed.

## 2.1 User/Market Demographics

Summarize the key market demographics that motivate your solution decisions. Describe target-market segments. Estimate the market’s size and growth by the number of potential users or the amount of money your customers spend, trying to meet needs that your product/enhancement would fulfill. Review major industry trends and technologies. Refer to a market analysis, where available.

## 2.2 User Personas

Describe the primary and secondary user personas (see Chapter 7). A thorough analysis might cover the following topics for each persona:

* Technical background and degree of sophistication  
* Key responsibilities
* Deliverables the user produces and for whom
* Trends that make the user’s job easier or more difficult  
* The user’s definition of success and how the user is rewarded
* Problems that interfere with success

## 2.3  User Environment

Describe the working environment of the target user. Here are some suggestions.

* How many people are involved in completing the task? Is this changing?
* How long is a task cycle? How much time is spent in each activity? Is this changing?
* Are there any unique environmental constraints: controlled environment, mobile, outdoors, and so on?
* Which system platforms are in use today? Future platforms?
* What other applications are in use? Does your application need to integrate with them?

## 2.4 Key User Needs

List the key problems or needs as perceived by the user. Clarify the following issues for each problem.

* What are the reasons for this problem?
* How is it solved now?
* What solutions does the user envision?

Ranking and cumulative-voting techniques for these needs indicate problems that must be solved versus issues the user would like to be solved.

## 2.5 Alternatives and Competition

Identify any alternatives available to the user. These can include buying a competitor’s product, building a homegrown solution, or simply maintaining the status quo. List any known competitive choices that exist. Include the major strengths and weaknesses of each competitor as perceived by the end user.

### 2.5.1 Competitor 1

### 2.5.2 Competitor 2

# 3 Stakeholders

Identify the program stakeholders, their needs, and their degree of involvement with the system. A table such as the following can be effective:

Project<br/>Stakeholder | Degree of<br/> Involvement | Product Needs | Program Needs
:---- | :---- | :---- | :----
Stakeholder 1 | | |
Stakeholder 2 | | |

# 4 Product Overview

This section provides a high-level view of the solution capabilities, interfaces to other applications, and systems configurations. This section usually consists of five subsections, as follows.

## 4.1 Product Perspective

This subsection should put the product in perspective to other related products and the user’s environment. If the product is independent and totally self-contained, state so. If the product is a component of a larger system, this subsection should relate how these systems interact and should identify the relevant interfaces among the systems. One easy way to display the major components of the larger system, interconnections, and external interfaces is via a system context block diagram.

## 4.2 Product Position Statement

Provide an overall statement summarizing, at the highest level, the unique position the product intends to fill in the marketplace. Moore [1991] calls this the product position statement and recommends the following format.

For | (target customer)
:-- | :----------------
Who | (statement of the need or opportunity)
The (product name) | is a (product category)
That | (statement of key benefit, that is, compelling rea
son to buy)
Unlike | (primary competitive alternative)
Our product | (statement of primary differentiation)

A product position statement communicates the intent of the application and the importance of the program to all stakeholders.

## 4.3 Summary of Capabilities

Summarize the major benefits and features the product will provide. Organize the features so that the list is understandable to any stakeholder. A simple table listing the key benefits and their supporting features, as shown below, might suffice.

Solution Features | Customer Benefit
:---------------- | :---------------
Feature 1         | Benefit 1
Feature 2         | Benefit 2

## 4.4 Assumptions and Dependencies

List any assumptions that, if changed, will alter the vision for the product.

## 4.5 Cost and Pricing

Describe any relevant cost and pricing constraints, because these can directly impact the solution definition and implementation.

# 5 Product Features

This section describes the intended product features. Features provide the system capabilities that are necessary to deliver benefits to the users. Feature descriptions should be short and pithy, a key phrase, perhaps followed by one or two sentences of explanation.

Use a level of abstraction high enough to be able to describe the system with a maximum of 25 to 50 features. Each feature should be perceivable by users, operators, or other external systems.

## 5.1 Feature 1

## 5.2 Feature 2

# 6 Exemplary Use Cases

[Optional] You may want to describe a few exemplary use cases, perhaps those that are architecturally significant or those that will most readily help the reader understand how  the system is intended to be used.

# 7 Nonfunctional Requirements

This section records other system requirements including nonfunctional requirements (constraints) imposed on the system (see Chapter 17).

## 7.1 Usability

## 7.2 Reliability

## 7.3 Performance

## 7.4 Supportability

## 7.5 Other Requirements

### 7.5.1 Applicable Standards

List all standards the product must comply with, such as legal and regulatory, communications standards, platform compliance standards, and quality and safety standards.

### 7.5.2 System Requirements

Define any system requirements necessary to support the application. These may include the  host  operating systems  and  network  platforms,  configurations, communication, peripherals, and companion software.

### 7.5.3 Licensing, Security, and Installation

Licensing, security, and installation issues can also directly  impact the development effort. Installation requirements may affect coding or create the need for separate installation software.

# 8 Documentation Requirements

This section describes the documentation that must be developed to support successful deployment and use.

## 8.1 User Manual

Describe the intent of the user manual. Discuss desired length, level of detail, need for index and glossary, tutorial versus reference manual strategy, and so on. Formatting, electronic distribution, and printing constraints should also be identified.

## 8.2 Online Help

The nature of these systems is unique to application development since they combine aspects of programming and hosting, such as hyperlinks and web services, with aspects of technical writing, such as organization, style, and presentation.

## 8.3  Installation Guides, Configuration, “Read Me” File

A document that includes installation instructions and configuration guidelines is typically necessary. Also, a “read  me” file is often included as a standard component. The “read me” file may include a “What’s New with This Release” section and a discussion of compatibility issues with earlier releases. Most users also appreciate publication of any known defects and workarounds.

## 8.4 Labeling and Packaging

Defines the requirements for labeling to be incorporated into the code. Examples include copyright  and  patent notices,  corporate  logos,  standardized  icons,  and  other  graphic elements.

## 9 Glossary

The glossary defines terms that are unique to the program. Include any acronyms or abbreviations that need to be understood by users or other readers.
