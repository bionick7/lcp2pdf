import pygame
import pygame.freetype

pygame.init()
pygame.font.init()

FONT_SIZE = 64

screen = pygame.display.set_mode((FONT_SIZE*14, FONT_SIZE*8))
screen.fill((255, 255, 255))
my_font = pygame.freetype.Font('barlow/Barlow-Regular.ttf', 30)
compcon = pygame.freetype.Font('compcon.ttf', FONT_SIZE)

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
    for i in range(8*14):
        x = i % 14
        y = i // 14
        compcon.render_to(screen, (x*FONT_SIZE, y*FONT_SIZE), chr(i+0xE900), (0, 0, 0))
    pygame.display.update()