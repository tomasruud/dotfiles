(import spork/json)
(use judge)

(defn render [input]
  (as->
    (json/decode input false true) _

    [(when-let [model (get-in _ ["model" "display_name"])]
       (string model "/mod"))

     (when-let [effort (get-in _ ["effort" "level"])]
       (string effort "/eff"))

     (when-let [used (get-in _ ["context_window" "used_percentage"])]
       (string/format "%.0f%%/ctx" used))

     (when-let [used (get-in _ ["rate_limits" "five_hour" "used_percentage"])]
       (string/format "%.0f%%/5h" used))

     (when-let [used (get-in _ ["rate_limits" "seven_day" "used_percentage"])]
       (string/format "%.0f%%/7d" used))]

    (filter identity _)

    (string/join _ " ")))


(defn main [& _]
  (->
    (file/read stdin :all)
    render
    print))

(def test-input ```
{
  "cwd": "/Users/testuser/projects/example",
  "session_id": "00000000-0000-0000-0000-000000000000",
  "session_name": "test-session",
  "prompt_id": "550e8400-e29b-41d4-a716-446655440000",
  "transcript_path": "/Users/testuser/.claude/projects/-Users-testuser-projects-example/00000000-0000-0000-0000-000000000000.jsonl",
  "model": {
    "id": "claude-fable-5",
    "display_name": "Fable"
  },
  "workspace": {
    "current_dir": "/Users/testuser/projects/example",
    "project_dir": "/Users/testuser/projects/example",
    "added_dirs": ["/Users/testuser/projects/other"],
    "git_worktree": "feature-xyz",
    "repo": {
      "host": "github.com",
      "owner": "acme",
      "name": "example"
    }
  },
  "version": "2.1.196",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 1.23456,
    "total_duration_ms": 4500000,
    "total_api_duration_ms": 230000,
    "total_lines_added": 156,
    "total_lines_removed": 23
  },
  "context_window": {
    "total_input_tokens": 155000,
    "total_output_tokens": 12000,
    "context_window_size": 200000,
    "used_percentage": 77.5,
    "remaining_percentage": 22.5,
    "current_usage": {
      "input_tokens": 85000,
      "output_tokens": 12000,
      "cache_creation_input_tokens": 50000,
      "cache_read_input_tokens": 20000
    }
  },
  "exceeds_200k_tokens": false,
  "effort": {
    "level": "high"
  },
  "thinking": {
    "enabled": true
  },
  "rate_limits": {
    "five_hour": {
      "used_percentage": 23.5,
      "resets_at": 1783425600
    },
    "seven_day": {
      "used_percentage": 41.2,
      "resets_at": 1783857600
    }
  },
  "vim": {
    "mode": "NORMAL"
  },
  "agent": {
    "name": "security-reviewer"
  },
  "pr": {
    "number": 1234,
    "url": "https://github.com/acme/example/pull/1234",
    "review_state": "pending"
  },
  "worktree": {
    "name": "my-feature",
    "path": "/Users/testuser/projects/example/.claude/worktrees/my-feature",
    "branch": "worktree-my-feature",
    "original_cwd": "/Users/testuser/projects/example",
    "original_branch": "main"
  }
}
```)

(test (render test-input) "Fable/mod 78%/ctx 24%/5h 41%/7d")
