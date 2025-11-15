import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rika_and_morti_characters/widgets/character_card.dart';
import 'package:rika_and_morti_characters/providers/characyter_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) {
              context.read<CharacterProvider>().setSortOption(option);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.name,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('Sort by Name'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.status,
                child: Row(
                  children: [
                    Icon(Icons.health_and_safety),
                    SizedBox(width: 8),
                    Text('Sort by Status'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.species,
                child: Row(
                  children: [
                    Icon(Icons.pets),
                    SizedBox(width: 8),
                    Text('Sort by Species'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add characters to favorites by tapping the star icon',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final character = provider.favorites[index];
              return Dismissible(
                key: Key('favorite_${character.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                onDismissed: (direction) {
                  provider.toggleFavorite(character);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${character.name} removed from favorites'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => provider.toggleFavorite(character),
                      ),
                    ),
                  );
                },
                child: CharacterCard(
                  character: character,
                  onFavoritePressed: () => provider.toggleFavorite(character),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
