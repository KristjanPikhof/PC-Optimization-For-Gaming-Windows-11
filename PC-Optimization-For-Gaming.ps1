Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Custom colors
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
    $selectedTasks = $checkboxes | Where-Object { $_.Checked } | ForEach-Object { $_.Text }
    $progressBar.Value = 0
    $statusLabel.Text = "Starting optimization..."
    $runButton.Enabled = $false
    $cancelButton.Enabled = $false

    foreach ($task in $selectedTasks) {
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
        $progressBar.Value += (100 / $selectedTasks.Count)
    }

    $progressBar.Value = 100
    $statusLabel.Text = "Optimization completed! You can now close the application."
    $runButton.Enabled = $true
    $cancelButton.Enabled = $true
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
    $logTextBox.AppendText("$message`r`n")
    $logTextBox.ScrollToCaret()
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
    Log-Message "Emptying Recycle Bin..."
    try {
        $shell = New-Object -ComObject Shell.Application
        $recycleBin = $shell.Namespace(0xA)
        $itemsInBin = $recycleBin.Items().Count
        
        if ($itemsInBin -eq 0) {
            Log-Message "Recycle Bin is already empty."
        } else {
            $recykleBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Force }
            Log-Message "Recycle Bin emptied successfully. $itemsInBin item(s) removed."
        }
    }
    catch {
        Log-Message ("Error emptying Recycle Bin: {0}" -f $_.Exception.Message)
    }
    finally {
        if ($null -ne $shell) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
        }
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
}

function Set-CloudflareDNS {
    $statusLabel.Text = "Setting Cloudflare DNS..."
    Log-Message "Setting Cloudflare DNS..."
    
    $networkAdapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    
    foreach ($adapter in $networkAdapters) {
        try {
            $adapterName = $adapter.Description
            $currentDNS = $adapter.DNSServerSearchOrder
            
            Log-Message "Checking adapter: $adapterName"
            
            # Check if DNS is already set to Cloudflare
            if ($currentDNS -contains "1.1.1.1" -and $currentDNS -contains "1.0.0.1") {
                Log-Message "Cloudflare DNS already set for adapter: $adapterName. Skipping."
                continue
            }

            # Get the current adapter status
            $netAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -eq $adapterName }
            if ($netAdapter.Status -ne "Up") {
                Log-Message "Adapter $adapterName is not in 'Up' state. Current state: $($netAdapter.Status). Skipping."
                continue
            }

            $result = $adapter.SetDNSServerSearchOrder(@("1.1.1.1", "1.0.0.1"))
            
            if ($result.ReturnValue -eq 0) {
                Log-Message "Cloudflare DNS set successfully for adapter: $adapterName"
            } else {
                Log-Message "Failed to set Cloudflare DNS for adapter: $adapterName. Error code: $($result.ReturnValue)"
                Log-Message "Current DNS servers: $($currentDNS -join ', ')"
            }
        }
        catch {
            Log-Message "Error setting Cloudflare DNS for adapter: $adapterName. Error: $($_.Exception.Message)"
        }
    }
    
    Log-Message "Cloudflare DNS setting process completed."
}

$form.ShowDialog()
