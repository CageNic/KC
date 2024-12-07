# to work on page iteration

# tag - a
# attribute - href
# tag - img
# attribute - src

use LWP::UserAgent;
use HTML::TreeBuilder;
use URI::URL;

# Create a UserAgent to fetch the page
my $ua = LWP::UserAgent->new;
$ua->timeout(10);

# The URL to scrape
my $url = "";

# Fetch the page
my $response = $ua->get($url);
if ($response->is_success) {
    print "Successfully fetched the page.\n";
    my $content = $response->decoded_content;

    # Parse the HTML content into a tree
    my $tree = HTML::TreeBuilder->new_from_content($content);

    # Extract and print all <a> tags (links)
    my @links = $tree->find_by_tag_name('a');
    while (@links) {
            my $link = shift @links;
        my $href = $link->attr('href');
        if ($href) {
            my $abs_url = URI::URL->new($href, $url);
            print "Link: " . $abs_url->abs . "\n";
        }
    }

    # Extract and print all <img> tags (images)
    my @images = $tree->find_by_tag_name('img');
    foreach my $img (@images) {
        my $src = $img->attr('src');
        print "Image source: $src\n" if $src;
    }

    # Clean up
    $tree = $tree->delete;
} else {
    die "Failed to fetch the page: " . $response->status_line . "\n";
}
