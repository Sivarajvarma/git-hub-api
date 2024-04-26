#!/bin/bash

# Check if organization name is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <organization_name>"
    exit 1
fi

ORG_NAME="$1"

# GitHub API endpoint for listing organization members
USERS_API_ENDPOINT="https://api.github.com/orgs/${ORG_NAME}/members"

# GitHub API endpoint for listing organization repositories
REPOS_API_ENDPOINT="https://api.github.com/orgs/${ORG_NAME}/repos"

# Function to fetch users
fetch_users() {
    # Send a GET request to the GitHub API for users
    users_response=$(curl -s "${USERS_API_ENDPOINT}")
    
    # Check if the request was successful
    if [ $? -ne 0 ]; then
        echo "Failed to fetch organization members. Check your internet connection."
        exit 1
    fi
    
    # Parse the JSON response and extract user information
    user_info=$(echo "$users_response" | jq -r '.[].login')
    
    # Check if any users are found
    if [ -z "$user_info" ]; then
        echo "No users found in organization '${ORG_NAME}'."
    else
        # Print the list of users
        echo "Users in organization '${ORG_NAME}':"
        echo "$user_info"
    fi
}

# Function to fetch repositories
fetch_repos() {
    # Send a GET request to the GitHub API for repositories
    repos_response=$(curl -s "${REPOS_API_ENDPOINT}")
    
    # Check if the request was successful
    if [ $? -ne 0 ]; then
        echo "Failed to fetch organization repositories. Check your internet connection."
        exit 1
    fi
    
    # Parse the JSON response and extract repository information
    repo_info=$(echo "$repos_response" | jq -r '.[].name')
    
    # Check if any repositories are found
    if [ -z "$repo_info" ]; then
        echo "No repositories found in organization '${ORG_NAME}'."
    else
        # Print the list of repositories
        echo "Repositories in organization '${ORG_NAME}':"
        echo "$repo_info"
    fi
}

# Main function to run the script
main() {
    fetch_users
    echo
    fetch_repos
}

# Execute the main function
main
