/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Factory
 - - - - - - - - - -
 ![Factory Diagram](Factory_Diagram.png)
 
 The factory pattern provides a way to create objects without exposing creation logic. It involves two types:
 
 1. The **factory** creates objects.
 2. The **products** are the objects that are created.
 
 ## Code Example
 */
public struct JobApplicant {
  public let name: String
  public let email: String
  public var status: Status
  
  public enum Status {
    case new
    case interview
    case hired
    case rejected
  }
}

public struct Email {
  public let subject: String
  public let messageBody: String
  public let recipientEmail: String
  public let senderEmail: String
}

// 1
public struct EmailFactory {
  
  // 2
  public let senderEmail: String
  
  // 3
  public func createEmail(to recipient: JobApplicant) -> Email {
    switch recipient.status {
    case .new:
      return Email(
        subject: "We Received Your Application",
        messageBody: "Thanks for applying for a job here! " +
        "You should hear from us in 17-42 business days.",
        recipientEmail: recipient.email,
        senderEmail: senderEmail)
      
    case .interview:
      return Email(
        subject: "We Want to Interview You",
        messageBody: "Thanks for your resume, \(recipient.name)! " +
        "Can you come in for an interview in 30 minutes?",
        recipientEmail: recipient.email,
        senderEmail: senderEmail)
      
    case .hired:
      return Email(
        subject: "We Want to Hire You",
        messageBody: "Congratulations, \(recipient.name)! " +
        "We liked your code, and you smelled nice. We want to offer you a position! Cha-ching! $$$",
        recipientEmail: recipient.email,
        senderEmail: senderEmail)
      
    case .rejected:
      return Email(
        subject: "Thanks for Your Application",
        messageBody: "Thank you for applying, \(recipient.name). " +
          "We have decided to move forward with other candidates. " +
        "Please remember to wear pants next time!",
        recipientEmail: recipient.email,
        senderEmail: senderEmail)
    }
  }
}

var jackson = JobApplicant(name: "Jackson Smith",
                           email: "jackson.smith@example.com",
                           status: .new)

let emailFactory = EmailFactory(senderEmail: "RaysMinions@RaysCoffeeCo.com")

// New
print(emailFactory.createEmail(to: jackson), "\n")

// Interview
jackson.status = .interview
print(emailFactory.createEmail(to: jackson), "\n")

// Hired
jackson.status = .hired
print(emailFactory.createEmail(to: jackson), "\n")
