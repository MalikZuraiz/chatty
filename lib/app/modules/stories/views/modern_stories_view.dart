import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ModernStoriesView extends StatefulWidget {
  const ModernStoriesView({super.key});

  @override
  State<ModernStoriesView> createState() => _ModernStoriesViewState();
}

class _ModernStoriesViewState extends State<ModernStoriesView> {
  bool isGridView = false;

  final List<StoryUser> stories = [
    StoryUser(
      id: '1',
      name: 'Your Story',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=YourStory',
      isYours: true,
      hasUnviewed: false,
    ),
    StoryUser(
      id: '2',
      name: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      hasUnviewed: true,
      time: '2h ago',
    ),
    StoryUser(
      id: '3',
      name: 'Alex Jordan',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      hasUnviewed: true,
      time: '4h ago',
    ),
    StoryUser(
      id: '4',
      name: 'Maya Patel',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      hasUnviewed: false,
      time: '8h ago',
    ),
    StoryUser(
      id: '5',
      name: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      hasUnviewed: true,
      time: '10h ago',
    ),
    StoryUser(
      id: '6',
      name: 'Emma Wilson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      hasUnviewed: false,
      time: '12h ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0712),
            Color(0xFF1A1A2E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: isGridView ? _buildGridView() : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stories',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${stories.length} active stories',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildActionButton(
            icon: isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
            onTap: () => setState(() => isGridView = !isGridView),
            color: const Color(0xFFFF006E),
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            icon: Icons.camera_alt_rounded,
            onTap: _createStory,
            color: const Color(0xFF06FFA5),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      itemCount: stories.length,
      itemBuilder: (context, index) => _buildStoryListItem(stories[index]),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) => _buildStoryGridItem(stories[index]),
    );
  }

  Widget _buildStoryListItem(StoryUser story) {
    return GestureDetector(
      onTap: () => _viewStory(story),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _buildStoryAvatar(story, size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story.isYours ? 'Tap to add story' : story.time ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (story.hasUnviewed && !story.isYours)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF006E),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryGridItem(StoryUser story) {
    return GestureDetector(
      onTap: () => _viewStory(story),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: story.hasUnviewed && !story.isYours
                ? const Color(0xFFFF006E)
                : Colors.white.withOpacity(0.1),
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: story.avatar,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white.withOpacity(0.1),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.white.withOpacity(0.1),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!story.isYours && story.time != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        story.time!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (story.isYours)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF06FFA5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryAvatar(StoryUser story, {required double size}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: story.hasUnviewed && !story.isYours
            ? const LinearGradient(
                colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
              )
            : null,
        border: !story.hasUnviewed || story.isYours
            ? Border.all(color: Colors.white.withOpacity(0.2), width: 2)
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1A1A2E), width: 3),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: story.avatar,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.white.withOpacity(0.1),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              size: size * 0.5,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  void _viewStory(StoryUser story) {
    if (story.isYours) {
      _createStory();
    } else {
      // TODO: Navigate to story viewer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Viewing ${story.name}\'s story'),
          backgroundColor: const Color(0xFF1A1A2E),
        ),
      );
    }
  }

  void _createStory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Create Story',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStoryOption(Icons.camera_alt, 'Camera', const Color(0xFF00D4FF)),
                _buildStoryOption(Icons.photo_library, 'Gallery', const Color(0xFFFF006E)),
                _buildStoryOption(Icons.text_fields, 'Text', const Color(0xFF06FFA5)),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class StoryUser {
  final String id;
  final String name;
  final String avatar;
  final bool isYours;
  final bool hasUnviewed;
  final String? time;

  StoryUser({
    required this.id,
    required this.name,
    required this.avatar,
    this.isYours = false,
    this.hasUnviewed = false,
    this.time,
  });
}
