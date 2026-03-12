# Make sure you are in the directory that is the root of your music collection
cd ~/Musk/

# The command with the added check
cat ~/tmp/rdo_list.m3u | xargs -d '\n' -I {} bash -c '
    src_file="{}"
    
    # Exit if the line is empty
    [[ -z "$src_file" ]] && exit 0
    
    src_dir=$(dirname "$src_file")
    dest_dir="$src_dir/mpc_enc"
    base_name=$(basename "$src_file" .flac)
    dest_file="$dest_dir/$base_name.mpc"
    
    mkdir -p "$dest_dir"
    mpcenc --extreme "$src_file" "$dest_file"
'
# Print 'DONE' message
echo 'CONVERSION COMPLETE!'
