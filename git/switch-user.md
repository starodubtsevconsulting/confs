# Git User Switcher

A simple script to manage multiple Git user profiles and switch between them seamlessly.

## Overview

The `switch-user.sh` script manages Git user configurations by storing profiles in Git's global config and linking them with stored credentials in `~/.git-credentials`.

## Architecture

```mermaid
graph TB
    A[switch-user.sh] --> B[Git Global Config]
    A --> C[~/.git-credentials]
    
    B --> D[switch-user.profile.*.name]
    B --> E[switch-user.profile.*.email]
    B --> F[credential.username]
    B --> G[user.name]
    B --> H[user.email]
    
    C --> I[GitHub PATs]
    
    subgraph "Profile Storage"
        D
        E
    end
    
    subgraph "Active Config"
        F
        G
        H
    end
    
    subgraph "Credentials"
        I
    end
```

## Data Flow

```mermaid
sequenceDiagram
    participant U as User
    participant S as Script
    participant GC as Git Config
    participant CR as ~/.git-credentials
    
    U->>S: Run script
    S->>GC: Read profiles (switch-user.profile.*)
    S->>GC: Read current user (credential.username)
    S->>U: Show users list with current marked
    
    alt Switch User
        U->>S: Choose switch + user number
        S->>GC: Set credential.username
        S->>GC: Set user.name from profile
        S->>GC: Set user.email from profile
        S->>U: Confirm current user
    end
    
    alt Add User
        U->>S: Choose add
        S->>U: Prompt for username, name, email
        S->>U: Prompt for PAT (hidden)
        S->>GC: Store profile (switch-user.profile.*)
        S->>CR: Store credentials (https://user:pat@github.com)
        S->>GC: Set as current user
    end
    
    alt Delete User
        U->>S: Choose delete + user number
        S->>GC: Remove profile (switch-user.profile.*)
        S->>CR: Remove credentials
        S->>GC: Unset credential.username if current
    end
```

## Profile System

Each user profile consists of:

1. **Profile Keys** (in Git global config):
   - `switch-user.profile.{username}.name` - Display name for commits
   - `switch-user.profile.{username}.email` - Email for commits

2. **Active Configuration** (in Git global config):
   - `credential.username` - Current GitHub username
   - `user.name` - Current commit name
   - `user.email` - Current commit email

3. **Stored Credentials** (in `~/.git-credentials`):
   - `https://{username}:{pat}@github.com` - GitHub authentication

## Migration Process

```mermaid
flowchart TD
    A[Script starts] --> B{Profiles exist?}
    B -->|No| C{~/.git-credentials exists?}
    B -->|Yes| D[Load profiles]
    
    C -->|No| E[Show empty list]
    C -->|Yes| F{Migration flag set?}
    
    F -->|Yes| E
    F -->|No| G[Extract usernames from credentials]
    
    G --> H[Create profile for current user]
    G --> I[Create placeholder profiles for others]
    
    H --> J[Set migration flag]
    I --> J
    J --> D
    
    D --> K[Show users list]
```

## File Structure

```
~/.gitconfig                    # Git global configuration
├── credential.username         # Current GitHub user
├── user.name                   # Current commit name  
├── user.email                  # Current commit email
├── credential.helper           # Set to "store"
├── switch-user.migrated        # Migration completion flag
└── switch-user.profile.*       # User profiles
    ├── {user1}.name
    ├── {user1}.email
    ├── {user2}.name
    └── {user2}.email

~/.git-credentials              # Stored GitHub credentials
├── https://user1:pat1@github.com
└── https://user2:pat2@github.com
```

## Usage Examples

### Switching Users
```bash
./switch-user.sh
1) sstarodubtsev (current)
2) starodubtsevconsulting

1) switch
2) show  
3) add
4) delete
5) quit
Choose [1-5]: 1
User number [1-2]: 2
CURRENT USER IS: starodubtsevconsulting
```

### Adding New User
```bash
Choose [1-5]: 3
GitHub username: newuser
Name: New User
Email: new@example.com
Enter GitHub Personal Access Token (PAT) for 'newuser': [hidden]
CURRENT USER IS: newuser
```

### Viewing User Details
```bash
Choose [1-5]: 2
User number [1-2]: 1
User: sstarodubtsev
Name: Sergii Starodubtsev (sxm)
Email: user@domain.com
```

## Security Notes

- PATs are stored in plaintext in `~/.git-credentials` (readable only by user)
- The script sets `chmod 600` on `~/.git-credentials` for protection
- Profiles are stored in Git global config (also user-readable only)

## Dependencies

- Git (with credential.helper support)
- Bash 4.0+ (for arrays and modern syntax)
- Standard Unix tools: `sed`, `grep`, `mktemp`
