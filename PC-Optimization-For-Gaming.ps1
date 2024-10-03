if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    [System.Windows.Forms.MessageBox]::Show("Please run this script as an Administrator.", "Admin Rights Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$primaryColor = [System.Drawing.Color]::FromArgb(63, 81, 181)
$accentColor = [System.Drawing.Color]::FromArgb(255, 64, 129)
$backgroundColor = [System.Drawing.Color]::White
$textColor = [System.Drawing.Color]::FromArgb(33, 33, 33)

$form = New-Object System.Windows.Forms.Form
$form.Text = "PC Optimization Script"
$form.Size = New-Object System.Drawing.Size(500, 680)
$form.StartPosition = "CenterScreen"
$form.BackColor = $backgroundColor
$form.ForeColor = $textColor

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = [System.Drawing.Point]::new(20, 20)
$titleLabel.Size = New-Object System.Drawing.Size(460, 30)
$titleLabel.Text = "PC Optimization For Gaming"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $primaryColor
$form.Controls.Add($titleLabel)

$descriptionLabel = New-Object System.Windows.Forms.Label
$descriptionLabel.Location = [System.Drawing.Point]::new(20, 60)
$descriptionLabel.Size = New-Object System.Drawing.Size(460, 20)
$descriptionLabel.Text = "Select optimization tasks to run:"
$descriptionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($descriptionLabel)

$checkboxes = @()
$tasks = @(
    "Configure and Run Disk Cleanup",
    "Clear Temporary Files",
    "Clear Prefetch Files",
    "Clear Windows Update Cache",
    "Clear NVIDIA Caches",
    "Clear DNS Cache",
    "Empty Recycle Bin",
    "Set Cloudflare DNS (Fastest)"
)

for ($i = 0; $i -lt $tasks.Count; $i++) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Location = [System.Drawing.Point]::new(20, 90 + ($i * 30))
    $checkbox.Size = New-Object System.Drawing.Size(440, 25)
    $checkbox.Text = $tasks[$i]
    $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $form.Controls.Add($checkbox)
    $checkboxes += $checkbox
}

$selectAllButton = New-Object System.Windows.Forms.Button
$selectAllButton.Location = [System.Drawing.Point]::new(20, 350)
$selectAllButton.Size = New-Object System.Drawing.Size(120, 35)
$selectAllButton.Text = "Select All"
$selectAllButton.BackColor = $primaryColor
$selectAllButton.ForeColor = $backgroundColor
$selectAllButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$selectAllButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$selectAllButton.Add_Click({
    foreach ($checkbox in $checkboxes) {
        $checkbox.Checked = $true
    }
})
$form.Controls.Add($selectAllButton)

$deselectAllButton = New-Object System.Windows.Forms.Button
$deselectAllButton.Location = [System.Drawing.Point]::new(150, 350)
$deselectAllButton.Size = New-Object System.Drawing.Size(120, 35)
$deselectAllButton.Text = "Deselect All"
$deselectAllButton.BackColor = $primaryColor
$deselectAllButton.ForeColor = $backgroundColor
$deselectAllButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$deselectAllButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$deselectAllButton.Add_Click({
    foreach ($checkbox in $checkboxes) {
        $checkbox.Checked = $false
    }
})
$form.Controls.Add($deselectAllButton)

$runButton = New-Object System.Windows.Forms.Button
$runButton.Location = [System.Drawing.Point]::new(20, 400)
$runButton.Size = New-Object System.Drawing.Size(120, 35)
$runButton.Text = "Run"
$runButton.BackColor = $accentColor
$runButton.ForeColor = $backgroundColor
$runButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$runButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$runButton.Add_Click({
    try {
        $selectedTasks = $checkboxes | Where-Object { $_.Checked } | ForEach-Object { $_.Text }
        $progressBar.Value = 0
        $statusLabel.Text = "Starting optimization..."
        $runButton.Enabled = $false
        $cancelButton.Enabled = $false

        foreach ($task in $selectedTasks) {
            $startTime = Get-Date
            switch ($task) {
                "Configure and Run Disk Cleanup" { Invoke-DiskCleanup }
                "Clear Temporary Files" { Clear-TempFiles }
                "Clear Prefetch Files" { Clear-PrefetchFiles }
                "Clear Windows Update Cache" { Clear-WindowsUpdateCache }
                "Clear NVIDIA Caches" { Clear-NVIDIACaches }
                "Clear DNS Cache" { Clear-DNSCache }
                "Empty Recycle Bin" { Clear-RecycleBin }
                "Set Cloudflare DNS (Fastest)" { Set-CloudflareDNS }
            }
            $endTime = Get-Date
            $duration = $endTime - $startTime
            Log-Message ("Task '{0}' completed in {1:N2} seconds." -f $task, $duration.TotalSeconds)
            $progressBar.Value += (100 / $selectedTasks.Count)
        }

        $progressBar.Value = 100
        $statusLabel.Text = "Optimization completed! You can now close the application."
        $runButton.Enabled = $true
        $cancelButton.Enabled = $true

        $rebootPrompt = [System.Windows.Forms.MessageBox]::Show("Do you want to reboot your system now?", "Reboot Required", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
        if ($rebootPrompt -eq 'Yes') {
            Restart-Computer -Force
        }
    }
    catch {
        Log-Message "An unexpected error occurred: $($_.Exception.Message)"
        $statusLabel.Text = "An error occurred. Please check the log."
        $runButton.Enabled = $true
        $cancelButton.Enabled = $true
    }
})
$form.Controls.Add($runButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = [System.Drawing.Point]::new(150, 400)
$cancelButton.Size = New-Object System.Drawing.Size(120, 35)
$cancelButton.Text = "Close"
$cancelButton.BackColor = $primaryColor
$cancelButton.ForeColor = $backgroundColor
$cancelButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$cancelButton.Add_Click({
    $form.Close()
})
$form.Controls.Add($cancelButton)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = [System.Drawing.Point]::new(20, 450)
$progressBar.Size = New-Object System.Drawing.Size(440, 25)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$form.Controls.Add($progressBar)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = [System.Drawing.Point]::new(20, 485)
$statusLabel.Size = New-Object System.Drawing.Size(440, 20)
$statusLabel.Text = "Ready"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($statusLabel)

$logTextBox = New-Object System.Windows.Forms.TextBox
$logTextBox.Location = [System.Drawing.Point]::new(20, 515)
$logTextBox.Size = New-Object System.Drawing.Size(440, 80)
$logTextBox.Multiline = $true
$logTextBox.ScrollBars = "Vertical"
$logTextBox.ReadOnly = $true
$logTextBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$form.Controls.Add($logTextBox)

$openSourceLabel = New-Object System.Windows.Forms.LinkLabel
$openSourceLabel.Location = [System.Drawing.Point]::new(20, 605)
$openSourceLabel.Size = New-Object System.Drawing.Size(440, 20)
$openSourceLabel.Text = "This is open-source code created by Esmaabi"
$openSourceLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$openSourceLabel.LinkColor = $primaryColor
$openSourceLabel.Add_Click({
    Start-Process "https://github.com/KristjanPikhof/PC-Optimization-For-Gaming-Windows-11"
})
$form.Controls.Add($openSourceLabel)

function Log-Message {
    param([string]$message)
    if ($logTextBox -and $logTextBox.IsHandleCreated) {
        $logTextBox.Invoke([Action]{
            $logTextBox.AppendText("$message`r`n")
            $logTextBox.ScrollToCaret()
        })
    }
}

function Invoke-DiskCleanup {
    $statusLabel.Text = "Running Disk Cleanup..."
    Log-Message "Starting Disk Cleanup..."
    try {
        Start-Process -FilePath cleanmgr -ArgumentList '/sagerun:1' -Wait
        Log-Message "Disk Cleanup completed successfully."
    }
    catch {
        Log-Message "Error during Disk Cleanup: $($_.Exception.Message)"
    }
}

function Clear-TempFiles {
    $statusLabel.Text = "Clearing Temporary Files..."
    Log-Message "Clearing Temporary Files..."
    $tempFolders = @("$env:TEMP", "$env:WINDIR\Temp")
    foreach ($folder in $tempFolders) {
        try {
            Remove-Item "$folder\*" -Force -Recurse -ErrorAction SilentlyContinue
            Log-Message "Cleared temporary files in $folder"
        }
        catch {
            Log-Message ("Error clearing temporary files in {0}: {1}" -f $folder, $_.Exception.Message)
        }
    }
    Log-Message "Temporary Files clearing completed."
}

function Clear-PrefetchFiles {
    $statusLabel.Text = "Clearing Prefetch Files..."
    Log-Message "Clearing Prefetch Files..."
    try {
        Remove-Item "$env:WINDIR\Prefetch\*" -Force -ErrorAction SilentlyContinue
        Log-Message "Prefetch Files cleared successfully."
    }
    catch {
        Log-Message "Error clearing Prefetch Files: $($_.Exception.Message)"
    }
}

function Clear-WindowsUpdateCache {
    $statusLabel.Text = "Clearing Windows Update Cache..."
    Log-Message "Clearing Windows Update Cache..."
    try {
        $service = Get-Service -Name wuauserv

        if ($service.Status -eq 'Running') {
            Log-Message "Attempting to stop Windows Update service..."
            Stop-Service -Name wuauserv -Force -ErrorAction Stop
            Log-Message "Windows Update service stopped successfully."
        } else {
            Log-Message "Windows Update service is not running."
        }

        Remove-Item "$env:WINDIR\SoftwareDistribution\*" -Recurse -Force -ErrorAction Stop
        Log-Message "Windows Update cache files removed successfully."

        if ($service.Status -eq 'Stopped') {
            Log-Message "Attempting to start Windows Update service..."
            Start-Service -Name wuauserv -ErrorAction Stop
            Log-Message "Windows Update service started successfully."
        }

        Log-Message "Windows Update Cache cleared successfully."
    }
    catch {
        Log-Message ("Error clearing Windows Update Cache: {0}" -f $_.Exception.Message)
        
        if ($service.Status -eq 'Stopped') {
            try {
                Start-Service -Name wuauserv -ErrorAction Stop
                Log-Message "Windows Update service restarted after error."
            }
            catch {
                Log-Message ("Failed to restart Windows Update service: {0}" -f $_.Exception.Message)
            }
        }
    }
}

function Clear-NVIDIACaches {
    $statusLabel.Text = "Clearing NVIDIA Caches..."
    Log-Message "Clearing NVIDIA Caches..."
    $nvidiaCachePaths = @(
        "$env:LOCALAPPDATA\NVIDIA\GLCache",
        "$env:TEMP\NVIDIA Corporation\NV_Cache"
    )
    foreach ($path in $nvidiaCachePaths) {
        try {
            if (Test-Path $path) {
                Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
                Log-Message "Cleared NVIDIA cache in $path"
            }
        }
        catch {
            Log-Message ("Error clearing NVIDIA cache in {0}: {1}" -f $path, $_.Exception.Message)
        }
    }
    Log-Message "NVIDIA Caches clearing completed."
}

function Clear-DNSCache {
    $statusLabel.Text = "Clearing DNS Cache..."
    Log-Message "Clearing DNS Cache..."
    try {
        Clear-DnsClientCache
        Log-Message "DNS Cache cleared successfully."
    }
    catch {
        Log-Message "Error clearing DNS Cache: $($_.Exception.Message)"
    }
}

function Clear-RecycleBin {
    $statusLabel.Text = "Emptying Recycle Bin..."
    Log-Message "Starting to empty Recycle Bin..."
    try {
        $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c rd /s /q C:\`$Recycle.Bin" -WindowStyle Hidden -PassThru -Wait
        
        if ($process.ExitCode -eq 0) {
            Log-Message "Recycle Bin emptied successfully."
        } else {
            Log-Message "Failed to empty Recycle Bin. Exit code: $($process.ExitCode)"
        }
    }
    catch {
        Log-Message ("Error emptying Recycle Bin: {0}" -f $_.Exception.Message)
    }
    finally {
        $statusLabel.Text = "Recycle Bin operation completed."
    }
}

function Set-CloudflareDNS {
    $statusLabel.Text = "Setting Cloudflare DNS..."
    Log-Message "Setting Cloudflare DNS..."
    
    $networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    
    foreach ($adapter in $networkAdapters) {
        try {
            $adapterName = $adapter.Name
            Log-Message "Checking adapter: $adapterName"
            
            $outputIPv4Primary = netsh interface ipv4 set dns name="$adapterName" static 1.1.1.1 primary
            $outputIPv4Secondary = netsh interface ipv4 add dns name="$adapterName" 1.0.0.1 index=2
            Log-Message ("IPv4 DNS set result for {0}:" -f $adapterName)
            Log-Message ("  Primary: {0}" -f ($outputIPv4Primary -join " "))
            Log-Message ("  Secondary: {0}" -f ($outputIPv4Secondary -join " "))

            $outputIPv6Primary = netsh interface ipv6 set dns name="$adapterName" static 2606:4700:4700::1111 primary
            $outputIPv6Secondary = netsh interface ipv6 add dns name="$adapterName" 2606:4700:4700::1001 index=2
            Log-Message ("IPv6 DNS set result for {0}:" -f $adapterName)
            Log-Message ("  Primary: {0}" -f ($outputIPv6Primary -join " "))
            Log-Message ("  Secondary: {0}" -f ($outputIPv6Secondary -join " "))
        }
        catch {
            Log-Message "Error setting Cloudflare DNS for adapter: $adapterName. Error: $($_.Exception.Message)"
        }
    }
    
    Log-Message "Cloudflare DNS setting process completed."
    
    Log-Message "Verifying DNS settings:"
    $dnsServers = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq $adapterName }
    Log-Message ("Current IPv4 DNS servers for {0}: {1}" -f $adapterName, ($dnsServers.ServerAddresses -join ", "))
    
    $dnsServersV6 = Get-DnsClientServerAddress -AddressFamily IPv6 | Where-Object { $_.InterfaceAlias -eq $adapterName }
    Log-Message ("Current IPv6 DNS servers for {0}: {1}" -f $adapterName, ($dnsServersV6.ServerAddresses -join ", "))
}

function Save-LogToFile {
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Text Files (*.txt)|*.txt"
    $saveFileDialog.Title = "Save Log File"
    $saveFileDialog.ShowDialog()

    if ($saveFileDialog.FileName -ne "") {
        $logTextBox.Text | Out-File $saveFileDialog.FileName
        [System.Windows.Forms.MessageBox]::Show("Log saved successfully!", "Save Log", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
}

$saveLogButton = New-Object System.Windows.Forms.Button
$saveLogButton.Location = [System.Drawing.Point]::new(280, 400)
$saveLogButton.Size = New-Object System.Drawing.Size(120, 35)
$saveLogButton.Text = "Save Log"
$saveLogButton.BackColor = $primaryColor
$saveLogButton.ForeColor = $backgroundColor
$saveLogButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$saveLogButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$saveLogButton.Add_Click({ Save-LogToFile })
$form.Controls.Add($saveLogButton)

$form.ShowDialog()
