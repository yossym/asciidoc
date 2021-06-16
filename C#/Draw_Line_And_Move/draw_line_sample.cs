   private bool isMoving = false;
    private Point mouseDownPosition = Point.Empty;
    private Point mouseMovePosition = Point.Empty;
    private List<Tuple<Point, Point>> lines = new List<Tuple<Point, Point>>();

    private void PanelPaint(object sender, PaintEventArgs e)
    {
        var g = e.Graphics;
        Pen p = new Pen(Color.Red, 7);
        if (isMoving)
        {
            e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(panel1.BackColor);

            g.DrawLine(p, mouseDownPosition, mouseMovePosition);
            foreach (var line in lines)
            {
                g.DrawLine(p, line.Item1, line.Item2);
            }
        }
    }

    private void PanelMouseDown(object sender, MouseEventArgs e)
    {
        isMoving = true;
        mouseDownPosition = e.Location;
    }

    private void PanelMouseMove(object sender, MouseEventArgs e)
    {
        if (isMoving)
        {
            mouseMovePosition = e.Location;
            panel1.Invalidate();
        }
    }

    private void PanelMouseUp(object sender, MouseEventArgs e)
    {
        if (isMoving)
        {
            lines.Add(Tuple.Create(mouseDownPosition, mouseMovePosition));
        }
        isMoving = false;
    }
