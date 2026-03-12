import type { ReactNode } from "react";

interface CardProps {
  children: ReactNode;
  className?: string;
}

export default function Card({ children, className = "" }: CardProps) {
  return (
    <div
      className={`bg-secondary rounded-xl border-2 border-white shadow-lg shadow-white/20 p-6 ${className}`}
    >
      {children}
    </div>
  );
}
