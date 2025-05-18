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

;; Utility Functions

;; Confirms participant registration status
(define-private (participant-registered? (participant-id uint))
  (is-some (map-get? participant-profile-registry { participant-id: participant-id }))
)

;; Validates a single interest tag for compliance with system requirements
(define-private (validate-interest-tag (tag (string-ascii 30)))
  (and
    (> (len tag) u0)
    (< (len tag) u31)
  )
)

;; Ensures interest tag collection meets system requirements
(define-private (validate-interest-collection (tags (list 5 (string-ascii 30))))
  (and
    (> (len tags) u0)
    (<= (len tags) u5)
    (is-eq (len (filter validate-interest-tag tags)) (len tags))
  )
)

;; Verifies participant identity through blockchain credentials
(define-private (confirm-participant-identity
    (participant-id uint)
    (account-key principal)
  )
  (match (map-get? participant-profile-registry { participant-id: participant-id })
    profile (is-eq (get account-key profile) account-key)
    false
  )
)

;; Profile Management Functions

;; Creates new participant profile with comprehensive identity details
(define-public (register-new-participant
    (display-name (string-ascii 50))
    (personal-description (string-ascii 160))
    (interest-tags (list 5 (string-ascii 30)))
  )
  (let ((new-participant-id (+ (var-get collective-membership-count) u1)))
    ;; Comprehensive validation for all submitted fields
    (asserts! (and (> (len display-name) u0) (< (len display-name) u51))
      ERROR-INVALID-INPUT
    )
    (asserts!
      (and (> (len personal-description) u0) (< (len personal-description) u161))
      ERROR-INVALID-INPUT
    )
    (asserts! (validate-interest-collection interest-tags) ERROR-INVALID-INPUT)
    ;; Create permanent profile record in the registry
    (map-insert participant-profile-registry { participant-id: new-participant-id } {
      display-name: display-name,
      account-key: tx-sender,
      registration-block: stacks-block-height,
      personal-description: personal-description,
      interest-tags: interest-tags,
    })
    ;; Initialize default information access settings
    (map-insert information-access-permissions {
      participant-id: new-participant-id,
      observer-key: tx-sender,
    } { access-enabled: true }
    )
    ;; Update collective size tracker
    (var-set collective-membership-count new-participant-id)
    (ok new-participant-id)
  )
)

;; Records participant engagement event for analytical tracking
(define-public (log-participant-interaction (participant-id uint))
  (let ((current-metrics (default-to {
      last-engagement: u0,
      engagement-count: u0,
      recent-interaction: "None",
    }
      (map-get? participation-analytics-store { participant-id: participant-id })
    )))
    (asserts! (participant-registered? participant-id)
      ERROR-PARTICIPANT-NOT-FOUND
    )
    (map-set participation-analytics-store { participant-id: participant-id } {
      last-engagement: stacks-block-height,
      engagement-count: (+ (get engagement-count current-metrics) u1),
      recent-interaction: "interaction",
    })
    (ok true)
  )
)

;; Modifies a participant's interest tag selections
(define-public (update-interest-tags
    (participant-id uint)
    (new-interest-tags (list 5 (string-ascii 30)))
  )
  (let ((profile-data (unwrap!
      (map-get? participant-profile-registry { participant-id: participant-id })
      ERROR-PARTICIPANT-NOT-FOUND
    )))
    ;; Verify profile exists and requester has appropriate permissions
    (asserts! (participant-registered? participant-id)
      ERROR-PARTICIPANT-NOT-FOUND
    )
    (asserts! (is-eq (get account-key profile-data) tx-sender)
      ERROR-UNAUTHORIZED-ACTION
    )
    (asserts! (validate-interest-collection new-interest-tags)
      ERROR-INVALID-INPUT
    )
    ;; Apply the interest tag changes
    (map-set participant-profile-registry { participant-id: participant-id }
      (merge profile-data { interest-tags: new-interest-tags })
    )
    (ok true)
  )
)

;; Updates a participant's display identifier
(define-public (change-display-identifier
    (participant-id uint)
    (new-display-name (string-ascii 50))
  )
  (let ((profile-data (unwrap!
      (map-get? participant-profile-registry { participant-id: participant-id })
      ERROR-PARTICIPANT-NOT-FOUND
    )))
    ;; Authentication and validation checks
    (asserts! (participant-registered? participant-id)
      ERROR-PARTICIPANT-NOT-FOUND
    )
    (asserts! (is-eq (get account-key profile-data) tx-sender)
      ERROR-UNAUTHORIZED-ACTION
    )
    ;; Process the display name modification
    (map-set participant-profile-registry { participant-id: participant-id }
      (merge profile-data { display-name: new-display-name })
    )
    (ok true)
  )
)

;; Advanced System Operations

;; Streamlined pathway for expedited interest tag modifications
(define-public (express-interest-update
    (participant-id uint)
    (new-interest-tags (list 5 (string-ascii 30)))
  )
  (begin
    (asserts! (participant-registered? participant-id)
      ERROR-PARTICIPANT-NOT-FOUND
    )
    (asserts! (validate-interest-collection new-interest-tags)
      ERROR-INVALID-INPUT
    )
    (map-set participant-profile-registry { participant-id: participant-id }
      (merge
        (unwrap!
          (map-get? participant-profile-registry { participant-id: participant-id })
          ERROR-PARTICIPANT-NOT-FOUND
        ) { interest-tags: new-interest-tags }
      ))
    (ok "Interest tags successfully refreshed")
  )
)