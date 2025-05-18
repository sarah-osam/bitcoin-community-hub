;; Bitcoin Community Hub
;; A decentralized profile management system that enables 
;; Bitcoin and Stacks community members to create and manage
;; their digital identities while maintaining privacy control
;; and discovering others with shared interests.
;;
;; Built for Stacks Layer 2, fully Bitcoin-compliant.

;; Framework Constants

;; Ecosystem governance authority
(define-constant FRAMEWORK-ADMINISTRATOR tx-sender)

;; System response indicators
(define-constant ERROR-ACCESS-DENIED (err u500))
(define-constant ERROR-PARTICIPANT-NOT-FOUND (err u501))
(define-constant ERROR-PARTICIPANT-EXISTS (err u502))
(define-constant ERROR-INVALID-INPUT (err u503))
(define-constant ERROR-UNAUTHORIZED-ACTION (err u504))

;; System-Wide State Variables

;; Master counter tracking total registered participants
(define-data-var collective-membership-count uint u0)

;; Core Data Repositories

;; Central repository for participant profile information
(define-map participant-profile-registry
  { participant-id: uint }
  {
    display-name: (string-ascii 50),
    account-key: principal,
    registration-block: uint,
    personal-description: (string-ascii 160),
    interest-tags: (list 5 (string-ascii 30)),
  }
)

;; Analytics framework for tracking participant engagement metrics
(define-map participation-analytics-store
  { participant-id: uint }
  {
    last-engagement: uint,
    engagement-count: uint,
    recent-interaction: (string-ascii 50),
  }
)

;; Access control framework for profile information visibility
(define-map information-access-permissions
  {
    participant-id: uint,
    observer-key: principal,
  }
  { access-enabled: bool }
)