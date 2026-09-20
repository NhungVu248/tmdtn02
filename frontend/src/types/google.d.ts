// Khai báo tối thiểu cho Google Identity Services (window.google.accounts.id).
interface GoogleIdConfig {
  client_id: string
  callback: (response: { credential: string }) => void
}

interface GoogleIdButtonOptions {
  theme?: 'outline' | 'filled_blue' | 'filled_black'
  size?: 'small' | 'medium' | 'large'
  width?: number
  text?: 'signin_with' | 'signup_with' | 'continue_with' | 'signin'
  locale?: string
}

interface Window {
  google?: {
    accounts: {
      id: {
        initialize: (config: GoogleIdConfig) => void
        renderButton: (parent: HTMLElement, options: GoogleIdButtonOptions) => void
        prompt: () => void
      }
    }
  }
}
