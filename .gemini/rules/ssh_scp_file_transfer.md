# SSH & SCP File Transfer & Screenshot Workflow

## Guidelines for Remote File Uploads & Debugging

1. **SCP with SSH Host Aliases**:
   - When the user has an SSH host alias in their local `~/.ssh/config` (e.g., `Host vis-shiny` using `ProxyJump ewc-proxy`), provide exact single-line `scp` or `rsync` commands using the host alias:
     ```bash
     scp "/local/path/to/screenshot.png" vis-shiny:/home/eouser/suhi_lst_as/www/
     ```

2. **Always Quote Local File Paths**:
   - Local filenames (especially macOS screenshots) often contain spaces (e.g. `Screenshot 2026-08-06 at 17.10.34.png`). Always wrap the local path in double quotes (`""`).

3. **Inspecting Uploaded Screenshots**:
   - Use `view_file` on the uploaded image path (e.g. `/home/eouser/suhi_lst_as/www/Screenshot...`) to visually inspect UI elements, layouts, and contrast issues directly.
